### Configuration

```bash
git config --global user.name "[User name]" 
git config --global user.email "[user e-mail]"
```

> * git이 commit할 때 사용할 사용자 이름과 이메일 주소를 설정한다.
> * --local을 지정하면 현재 repository에만 적용할 사용자 정보를 설정할 수 있다.

### Initialization

```bash
$ git init
```

> * 현재 directory를 git repository로 초기화한다. 

```bash
$ git clone [Remote URL]
```

> * remote repository를 clone하여 local에 repository를 생성한다.

### Stage & Snapshot
```bash
$ git status
```

> * working directory의 변경 사항을 출력한다.

```bash
$ git add [File]
$ git add [Directory]
$ git add .
$ git add -A
```

> * 지정된 file을 staging area에 추가한다.
> * 지정된 directory 전체를 staging area에 추가할 수도 있다.
> * directory로 `.`을 지정해서 현재 directory내에 있는 모든 변경사항들을 한번에 staging area에 추가할 수도 있다.
> * `-A`를 지정해서 저장소의 안의 모든 파일을 한번에 staging area에 추가할 수도 있다.

```bash
$ git reset [File]
```

> * staging된 파일을 다시 unstage 상태로 되돌린다.

```bash
$ git reset --hard [File]
```

> * 지정된 파일을 최근 커밋 상태로 되돌린다.

```bash
$ git reset [Commit ID]
```

> * active branch를 지정된 commit의 상태로 되돌리고, 모든 staging되어 있는 변경사항을 되돌리지만, 작업중인 내용은 되돌리지 않는다.

```bash
$ git reset --hard [Commit ID]
```

> * active branch의 모든 변경사항을 버리고 지정된 commit의 상태로 되돌린다. 

```bash
$ git diff
$ git diff --staged
```

> * unstaged 상태의 변경사항들을 출력한다.
> * `--staged`를 지정하면 staged 상태의 변경사항들을 출력한다. 

```bash
$ git commit -m "[Message]"
```

> * staging된 변경사항들을 반영하는 commit을 생성한다.

```bash
$ git commit --amend
```

> * 가장 마지막 commit을 현재 staging되어 있는 내용과 병합한다. staging없이 단순히 commit message를 변경하는 용도로도 사용할 수 있다.

### Branch

```bash
$ git branch
```

> * branch 목록을 보여준다. *표시가 있는 branch가 현재 active branch이다.

```bash
$ git branch [Branch]
```

> * 현재 commit을 기준으로 새로운 branch를 만든다.

```bash
$ git checkout [Branch]
```

> * 지정된 branch로 active branch로 변경한다.

```bash
$ git merge [Branch]
```

> * 지정된 branch를 현재 active branch와 병합한다.

### Log

```bash
$ git log
$ git log -3
```

> * active branch의 모든 commit history를 출력한다.
> * `-n`을 지정하면 최대 n개 까지만 출력한다.

```bash
$ git log --follow [File]
```

> * 지정된 파일의 commit history를 출력한다.

### Tracking path changes

```bash
$ git rm [File]
```

> * 해당 파일을 삭제하고, 스테이지에서도 이를 제거한다.

```bash
$ git mv [Existing path] [New path]
```

> * 파일 위치를 변경하고 스테이지에 이를 기록한다.

### Share & Update

```bash
$ git remote add [Alias] [Remote URL]
```

> * remote url을 alias(별칭)로 추가한다.
> * 참고로 remote repository를 clone하면 *origin*이라는 별칭이 자동으로 붙기 때문에 alias로 *origin* 을 많이 사용한다.

```bash
$ git fetch [Alias]
```

> * alias로 지정된 remote repository에서 모든 branch를 가져온다.

```bash
$ git merge [Alias]/[Branch]
```

> * active branch에 remote branch의 내용을 병합한다.

```bash
$ git push [Alias] [Branch]
```

> * local branch의 commit을 지정된 remote repository의 branch 반영한다.

```bash
$ git pull
```

> * remote branch의 모든 commit을 가져와서 병합한다. (fetch & merge)
