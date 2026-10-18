#!/usr/bin/env python3
"""Restore this desktop snapshot. Preview by default; --apply writes on NEW install."""
import argparse, datetime, hashlib, io, json, os, pathlib, shutil, tarfile

ROOT=pathlib.Path(__file__).resolve().parents[1]
TEXT={'.qml','.js','.py','.json','.conf','.lua','.sh','.svg','.css','.rasi','.ini','.md','.theme','.toml','.scss','.txt','.rc','.xml','.xpm','.desktop'}
def digest(data):return hashlib.sha256(data).hexdigest()
def archive(manifest_name='manifest.json'):
    m=json.loads((ROOT/'assets'/manifest_name).read_text());parts=[]
    for part in m['parts']:
        if pathlib.Path(part['name']).name!=part['name']:raise ValueError('Unsafe archive part name')
        data=(ROOT/'assets'/part['name']).read_bytes()
        if len(data)!=part['bytes'] or digest(data)!=part['sha256']:raise ValueError('Archive part checksum mismatch')
        parts.append(data)
    data=b''.join(parts)
    if digest(data)!=m['sha256']:raise ValueError('Full archive checksum mismatch')
    return tarfile.open(fileobj=io.BytesIO(data),mode='r:xz'),m
def relative(name):
    p=pathlib.PurePosixPath(name)
    if p.is_absolute() or '..' in p.parts or not p.parts or p.parts[0]!='home':raise ValueError('Unsafe snapshot path')
    return pathlib.Path(*p.parts[1:])
def safe_parents(destination,home):
    for parent in destination.parents:
        if parent==home:break
        if parent.is_symlink():raise ValueError('Existing parent symlink needs review: '+str(parent))
def main():
    ap=argparse.ArgumentParser(description=__doc__)
    ap.add_argument('--home',type=pathlib.Path,default=pathlib.Path.home())
    ap.add_argument('--apply',action='store_true');ap.add_argument('--dry-run',action='store_true')
    args=ap.parse_args()
    if args.apply and args.dry_run:raise ValueError('Choose one mode')
    if args.apply:
        from fedora_common import require_fedora
        require_fedora()
        import importlib.util
        spec=importlib.util.spec_from_file_location('fedora_preflight',ROOT/'scripts/check-fedora.py')
        probe=importlib.util.module_from_spec(spec);spec.loader.exec_module(probe)
        probe.check()
    if args.home.is_symlink():raise ValueError('Home root symlink refused')
    home=args.home.resolve(strict=True)
    if home==pathlib.Path('/') or home.stat().st_uid!=os.getuid():raise ValueError('Run as destination user')
    files=[]
    for p in sorted((ROOT/'home').rglob('*')):
        if p.is_symlink():raise ValueError('Unexpected repository symlink')
        if p.is_file():files.append((relative(str(p.relative_to(ROOT))),p.read_bytes(),p.stat().st_mode&0o777))
    for manifest_name in ('manifest.json', 'zsh-manifest.json'):
        tf,meta=archive(manifest_name)
        members=tf.getmembers()
        if len(members)!=meta['member_count'] or sum(m.size for m in members)!=meta['unpacked_bytes']:raise ValueError('Asset inventory mismatch')
        for m in members:
            rel=relative(m.name)
            if not m.isfile():raise ValueError('Unexpected non-file archive member')
            files.append((rel,tf.extractfile(m).read(),m.mode))
        tf.close()
    if len({str(p) for p,_,_ in files})!=len(files):raise ValueError('Duplicate restore paths')
    links=json.loads((ROOT/'links.json').read_text())
    for rel,_,_ in files:safe_parents(home/rel,home)
    for link in links:
        rel=relative('home/'+link['path']);target=pathlib.Path(link['target'].replace('@@HOME@@',str(home)))
        if not target.is_relative_to(home) or '..' in target.parts:raise ValueError('External symlink refused')
        safe_parents(home/rel,home)
    print(('APPLY' if args.apply else 'PREVIEW')+f': {len(files)} files, {len(links)} home symlinks')
    print('Destination:',home)
    if not args.apply:
        print('No files written. Close desktop apps and inspect compatibility before --apply.');return
    os.umask(0o077)
    backup=home/'.dotfiles-conflicts'/datetime.datetime.now().strftime('%Y%m%d-%H%M%S-%f')
    changed=0
    def preserve(path,rel):
        if path.exists() or path.is_symlink():
            saved=backup/rel;saved.parent.mkdir(parents=True,exist_ok=True)
            shutil.move(str(path),str(saved))
    for rel,data,mode in files:
        dest=home/rel
        if dest.suffix in TEXT or dest.name in {'gsettings','config','.gtkrc-2.0','qmldir','.zshrc','.zprofile','.p10k.zsh'}:
            try:data=data.decode().replace('@@HOME@@',str(home)).encode()
            except UnicodeDecodeError:raise ValueError('Invalid text encoding')
        if dest.is_file() and not dest.is_symlink() and digest(dest.read_bytes())==digest(data):continue
        preserve(dest,rel);dest.parent.mkdir(parents=True,exist_ok=True)
        with dest.open('xb') as f:f.write(data)
        dest.chmod(mode);changed+=1
    for link in links:
        rel=relative('home/'+link['path']);dest=home/rel;target=link['target'].replace('@@HOME@@',str(home))
        if dest.is_symlink() and os.readlink(dest)==target:continue
        preserve(dest,rel);dest.parent.mkdir(parents=True,exist_ok=True);dest.symlink_to(target);changed+=1
    print('Changed:',changed,'Conflicts preserved under:',backup)
    print('No services enabled or login shell changed. Prayer API/location and private state are restored separately. Open a new Zsh session to check the restored prompt.')
if __name__=='__main__':
    try:main()
    except (OSError,ValueError,KeyError,tarfile.TarError) as e:raise SystemExit('FAILED: '+str(e))
