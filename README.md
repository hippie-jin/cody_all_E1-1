# Cody_All_E1-1 — 개발 워크스테이션 구축

## 1) 프로젝트 개요
터미널(CLI), Docker(OrbStack), Git/GitHub로 개발 환경을 직접 세팅하고, 실행 결과(로그·접속·데이터 유지)로 검증한다.

## 2) 실행 환경
- OS: macOS 15.7.9 (x86_64)
- Shell: bash 3.2.57
- Git: 2.39.5 (Apple Git-154)
- Docker: (3단계에서 기록 예정)

## 3) 수행 체크리스트
- [x] 터미널 기본 조작 및 폴더 구성
- [x] 권한 변경 실습
- [ ] Docker(OrbStack) 설치/점검
- [ ] hello-world / ubuntu 실행
- [ ] Dockerfile 빌드/실행
- [ ] 포트 매핑 접속(2회)
- [ ] 바인드 마운트 반영
- [ ] 볼륨 영속성
- [ ] Git 설정 + GitHub/VSCode 연동

## 4) 수행 로그

### 4-1) 터미널 조작 (원본: [logs/01_terminal_practice.log](logs/01_terminal_practice.log))
검증: 현재 위치(`pwd`), 목록(`ls -la`, 숨김 파일 `.hidden_config` 포함), 이동(`cd`), 생성(`mkdir`, `touch`), 복사(`cp`), 이동/이름변경(`mv`), 삭제(`rm`), 내용 확인(`cat`).

```text
$ mkdir practice
$ cd practice
$ pwd
/Users/hwang-jinjeon/코디세이/올인원/Cody_All_E1-1/practice
$ mkdir -p project/docs project/src
$ touch project/README.txt
$ echo hello codyssey > project/docs/note.txt
$ ls -la project
total 0
drwxr-xr-x@ 5 hwang-jinjeon  staff  160 10 30 00:07 .
drwxr-xr-x@ 3 hwang-jinjeon  staff   96 10 30 00:07 ..
drwxr-xr-x@ 3 hwang-jinjeon  staff   96 10 30 00:07 docs
-rw-r--r--@ 1 hwang-jinjeon  staff    0 10 30 00:07 README.txt
drwxr-xr-x@ 2 hwang-jinjeon  staff   64 10 30 00:07 src
$ cd project
$ pwd
/Users/hwang-jinjeon/코디세이/올인원/Cody_All_E1-1/practice/project
$ ls -a
.
..
docs
README.txt
src
$ cat docs/note.txt
hello codyssey
$ cp docs/note.txt docs/note_copy.txt
$ mv docs/note_copy.txt src/renamed.txt
$ mv src/renamed.txt src/moved_and_renamed.txt
$ touch .hidden_config
$ ls -la
total 0
drwxr-xr-x@ 6 hwang-jinjeon  staff  192 10 30 00:07 .
drwxr-xr-x@ 3 hwang-jinjeon  staff   96 10 30 00:07 ..
-rw-r--r--@ 1 hwang-jinjeon  staff    0 10 30 00:07 .hidden_config
drwxr-xr-x@ 3 hwang-jinjeon  staff   96 10 30 00:07 docs
-rw-r--r--@ 1 hwang-jinjeon  staff    0 10 30 00:07 README.txt
drwxr-xr-x@ 3 hwang-jinjeon  staff   96 10 30 00:07 src
$ ls -R
docs
README.txt
src

./docs:
note.txt

./src:
moved_and_renamed.txt
$ cat src/moved_and_renamed.txt
hello codyssey
$ rm src/moved_and_renamed.txt
$ rm -r src
$ ls -la
total 0
drwxr-xr-x@ 5 hwang-jinjeon  staff  160 10 30 00:07 .
drwxr-xr-x@ 3 hwang-jinjeon  staff   96 10 30 00:07 ..
-rw-r--r--@ 1 hwang-jinjeon  staff    0 10 30 00:07 .hidden_config
drwxr-xr-x@ 3 hwang-jinjeon  staff   96 10 30 00:07 docs
-rw-r--r--@ 1 hwang-jinjeon  staff    0 10 30 00:07 README.txt
$ cd ..
$ pwd
/Users/hwang-jinjeon/코디세이/올인원/Cody_All_E1-1/practice
$ ls ./project
docs
README.txt
$ ls /Users/hwang-jinjeon/코디세이/올인원/Cody_All_E1-1/practice/project
docs
README.txt
$ ls ../practice/project
docs
README.txt
```

절대 경로(`/Users/.../practice/project`)와 상대 경로(`./project`, `../practice/project`)는 결과가 같다.

### 4-2) 권한 실습 (원본: [logs/02_permissions.log](logs/02_permissions.log))
파일은 644→600→744(u+x)→644, 디렉토리는 755→000→755로 바꾸며 전후를 비교했다.
디렉토리를 000으로 바꾸자 `ls`와 `cat`이 모두 `Permission denied`가 되었다(디렉토리의 x는 진입 권한).

```text
$ mkdir perm_test
$ echo permission test > perm_test/file.txt
# [파일] 변경 전
$ ls -l perm_test/file.txt
-rw-r--r--@ 1 hwang-jinjeon  staff  16 10 30 00:07 perm_test/file.txt
$ stat -f "%Sp %Lp %N" perm_test/file.txt
-rw-r--r-- 644 perm_test/file.txt
$ chmod 600 perm_test/file.txt
# [파일] 600 적용 후
$ ls -l perm_test/file.txt
-rw-------@ 1 hwang-jinjeon  staff  16 10 30 00:07 perm_test/file.txt
$ chmod 644 perm_test/file.txt
# [파일] 644 복구 후 / 실행권한 추가(u+x)
$ chmod u+x perm_test/file.txt
$ ls -l perm_test/file.txt
-rwxr--r--@ 1 hwang-jinjeon  staff  16 10 30 00:07 perm_test/file.txt
$ chmod 644 perm_test/file.txt

# [디렉토리] 변경 전
$ ls -ld perm_test
drwxr-xr-x@ 3 hwang-jinjeon  staff  96 10 30 00:07 perm_test
$ chmod 000 perm_test
# [디렉토리] 000 적용 후 -> 접근 시도
$ ls -ld perm_test
d---------  3 hwang-jinjeon  staff  96 10 30 00:07 perm_test
$ ls perm_test
ls: perm_test: Permission denied
$ cat perm_test/file.txt
cat: perm_test/file.txt: Permission denied
$ chmod 755 perm_test
# [디렉토리] 755 복구 후
$ ls -ld perm_test
drwxr-xr-x@ 3 hwang-jinjeon  staff  96 10 30 00:07 perm_test
$ ls perm_test
file.txt
$ chmod 755 perm_test/file.txt
$ ls -l perm_test/file.txt
-rwxr-xr-x@ 1 hwang-jinjeon  staff  16 10 30 00:07 perm_test/file.txt
```

## 5) 트러블슈팅 (작성 중)
1. **OrbStack `brew install --cask orbstack` 실패** (진행 중)
   - 문제: `/usr/local/share/man/man8 is not writable by your user`로 설치 중단
   - 확인: 해당 디렉토리 소유자가 `root`, `sudo`는 비밀번호 필요
   - 해결/대안: 3단계에서 진행 (공식 설치 파일 직접 설치 등)
