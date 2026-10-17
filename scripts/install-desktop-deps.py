#!/usr/bin/env python3
"""Check dependencies; install ONLY with --apply on the NEW, fully updated system."""
import argparse,pathlib,re,subprocess
def main():
    p=argparse.ArgumentParser(description=__doc__);p.add_argument('--apply',action='store_true');p.add_argument('--dry-run',action='store_true');a=p.parse_args()
    if a.apply and a.dry_run:raise ValueError('Choose one mode')
    root=pathlib.Path(__file__).resolve().parents[1]
    packages=[v for v in (root/'packages/desktop-required.txt').read_text().splitlines() if v and not v.startswith('#')]
    if any(not re.fullmatch(r'[a-zA-Z0-9@+_.-]+',v) for v in packages):raise ValueError('Invalid package name')
    unavailable=[n for n in packages if subprocess.run(['pacman','-Si','--',n],stdout=subprocess.DEVNULL,stderr=subprocess.DEVNULL).returncode]
    if unavailable:raise ValueError('Missing/renamed packages; resolve before continuing: '+', '.join(unavailable))
    print('Required packages:',', '.join(packages))
    if a.apply:subprocess.run(['sudo','pacman','-S','--needed','--',*packages],check=True)
    else:print('PREVIEW: no installation performed.')
if __name__=='__main__':
    try:main()
    except (OSError,ValueError,subprocess.SubprocessError) as e:raise SystemExit('FAILED: '+str(e))
