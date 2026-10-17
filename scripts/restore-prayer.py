#!/usr/bin/env python3
"""Restore prayer API/settings from the PRIVATE Documents text file; preview default."""
import argparse,datetime,json,os,pathlib,shutil,urllib.parse
def main():
    p=argparse.ArgumentParser(description=__doc__)
    p.add_argument('--private-file',type=pathlib.Path,required=True)
    p.add_argument('--apply',action='store_true');p.add_argument('--dry-run',action='store_true')
    a=p.parse_args()
    if a.apply and a.dry_run:raise ValueError('Choose one mode')
    if a.private_file.is_symlink():raise ValueError('Private-file symlink refused')
    data=json.loads(a.private_file.read_text());url=urllib.parse.urlsplit(data['api_base'])
    if url.scheme!='https' or not url.hostname or url.username or url.password:raise ValueError('Invalid private HTTPS endpoint')
    folder=pathlib.Path.home()/'.config/island-shell'
    for parent in [folder,folder.parent]:
        if parent.is_symlink():raise ValueError('Configuration parent symlink requires review')
    print('Private prayer setup validated; values will not be printed.')
    if not a.apply:print('PREVIEW only; no configuration written.');return
    os.umask(0o077);folder.mkdir(parents=True,exist_ok=True)
    timestamp=datetime.datetime.now().strftime('%Y%m%d-%H%M%S-%f')
    api=folder/'prayer-api.json';settings=folder/'settings.json'
    merged=json.loads(settings.read_text()) if settings.is_file() else {}
    merged.update({k:v.replace('/home/user0',str(pathlib.Path.home())) if isinstance(v,str) else v for k,v in data.get('settings',{}).items() if k.startswith('prayer')})
    for target,value in [(api,{'api_base':data['api_base']}),(settings,merged)]:
        if target.is_symlink():raise ValueError('Configuration symlink refused')
        if target.exists():shutil.copy2(target,target.with_name(target.name+'.before-'+timestamp))
        with target.open('w') as f:json.dump(value,f,indent=2);f.write('\n')
        target.chmod(0o600)
    print('Private prayer setup restored locally. No request was sent and no secrets were printed.')
if __name__=='__main__':
    try:main()
    except (OSError,ValueError,KeyError) as e:raise SystemExit('FAILED: '+str(e))
