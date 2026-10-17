#!/usr/bin/env python3
"""Install reviewed repository packages on NEW CachyOS only. Dry-run default.
Foreign/manual software is always reported for source/recipe review, never auto-built.
No removal, service changes, automatic recipe trust or automatic system update.
"""
import argparse, hashlib, json, os, pathlib, re, subprocess, sys
KIT=pathlib.Path(__file__).resolve().parents[1]
def main():
    ap=argparse.ArgumentParser(description=__doc__)
    ap.add_argument('--execute',action='store_true');ap.add_argument('--dry-run',action='store_true')
    ap.add_argument('--new-install-ready',action='store_true',help='New CachyOS fully updated, repositories/keyrings/hardware configured.')
    a=ap.parse_args()
    if a.execute and a.dry_run:raise RuntimeError('Choose one mode.')
    if not (KIT/'review/FINALIZED.json').is_file():raise RuntimeError('Review unfinished: final reinstall lists do not exist. Continue application batches first.')
    manifest=json.loads((KIT/'review/FINALIZED.json').read_text())
    for name,expected in manifest['list_sha256'].items():
        if pathlib.Path(name).name!=name or hashlib.sha256((KIT/'review'/name).read_bytes()).hexdigest()!=expected:raise RuntimeError('Final list checksum mismatch; review a new plan revision.')
    wanted=(KIT/'review/final-repository-packages.txt').read_text().splitlines()
    if any(not re.fullmatch(r'[a-zA-Z0-9@+_.-]+',p) for p in wanted):raise RuntimeError('Invalid package name.')
    missing=[]
    for p in wanted:
        if subprocess.run(['pacman','-Si','--',p],stdout=subprocess.DEVNULL,stderr=subprocess.DEVNULL).returncode:missing.append(p)
    if missing:
        print('Missing/renamed repository packages (resolve before installing):\n'+'\n'.join(missing));raise RuntimeError('Package availability incomplete.')
    print('Reviewed repository packages:',len(wanted))
    print('pacman --needed preserves already installed packages. Dependency solver may retain an excluded app as a dependency.')
    if a.execute:
        if not a.new_install_ready:raise RuntimeError('Confirm base-system readiness on NEW installation first.')
        if wanted:subprocess.run(['sudo','pacman','-S','--needed','--',*wanted],check=True)
    else:print('DRY RUN: no installation executed.')
    for name in ['final-foreign-review.txt','final-foreign-dependency-review.txt','final-manual-review.txt','final-system-review.txt']:
        f=KIT/'review'/name
        if f.exists() and f.read_text().strip():
            print('REQUIRES MANUAL SOURCE/RECIPE REVIEW: '+str(f))
            print(f.read_text())
    print('Never build as root. Review PKGBUILD, .install, sources and checksums; then use build-foreign.sh with the reviewed source tree.')
if __name__=='__main__':
    try:main()
    except (RuntimeError,OSError,subprocess.SubprocessError) as e:print('FAILED: '+str(e),file=sys.stderr);sys.exit(1)
