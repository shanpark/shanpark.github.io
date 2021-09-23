### Configuration
```bash
# git에서 사용할 사용자 이름을 설정한다.
git config --global user.name "[User name]" 

# git에서 사용할 사용자 이메일 주소를 설정한다.
git config --global user.email "[user e-mail]"
```

### Initialization
```bash
# git repository 초기화
$ git init

# remote repository를 clone하여 local에 repository를 생성한다.
$ git clone [Remote URL]
```

### Stage & Snapshot
```bash
# working directory에서 변경된 파일 목록을 보여준다.
$ git status

# staging area에 지정된 file을 추가한다.
$ git add [File]

# working directory에서 staging된 파일을 다시 unstage 상태로 되돌린다.
$ git reset [File]

# staging area와 working directory를 가장 최근 커밋 상태로 되돌린다.
$ git reset --hard [File]

# 현재 branch를 지정된 commit의 상태로 되돌리고, 모든 staging되어 있는 변경사항을 되돌리지만, 작업중인 내용은 되돌리지 않는다.
$ git reset [Commit ID]

# 현재 branch를 지정된 Commit의 상태로 되돌린다. 그 이후의 모든 변경 내역을 버린다. 
$ git reset --hard [Commit ID]

# unstaged 상태의 변경사항들을 출력한다. 
$ git diff

# staged 상태의 변경사항들을 출력한다. 
$ git diff --staged

# staging된 변경사항들을 반영하는 Commit을 생성한다.
$ git commit -m "[Message]"

# 가장 마지막 commit을 현재 staging되어 있는 내용과 병합한다. staging없이 단순히 commit message를 변경하는 용도로도 사용할 수 있다.
$ git commit --amend
```

### Branch

```bash
# branch 목록을 보여준다. *표시가 있는 branch가 현재 active branch이다.
$ git branch

# 현재 commit을 기준으로 새로운 branch를 만든다.
$ git branch [Branch]

# 지정된 branch로 active branch로 변경한다.
$ git checkout [Branch]

# 지정된 branch를 현재 active branch와 병합한다.
$ git merge [Branch]
```

### Log

```bash
# active branch의 모든 commit history를 출력한다.
$ git log

# 지정된 파일의 commit history를 출력한다.
$ git log --follow [File]
```

### Tracking path changes

```bash
# 해당 파일을 삭제하고, 스테이지에서도 이를 제거한다.
$ git rm [File]

# 파일 위치를 변경하고 스테이지에 이를 기록한다.
$ git mv [Existing path] [New path]
```

### Share & Update

```bash
# remote url을 alias(별칭)로 추가한다.
$ git remote add [Alias] [Remote URL]

# alias로 지정된 remote repository에서 모든 branch를 가져온다.
$ git fetch [Alias]

# active branch에 remote branch의 내용을 병합한다.
$ git merge [Alias]/[Branch]

# local branch의 commit을 지정된 remote repository의 branch 반영한다.
$ git push [Alias] [Branch]

# remote branch의 모든 commit을 가져와서 병합한다. (fetch & merge)
$ git pull
```
