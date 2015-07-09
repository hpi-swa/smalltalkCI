# filetreeCI


## .travis.yml Template
```yml
env:
- BASELINE=MyProject

install:
   - export PROJECT_HOME="$(pwd)"
   - cd $HOME
   - wget -q -O filetreeCI.zip https://github.com/fniephaus/filetreeCI/archive/master.zip
   - unzip -q filetreeCI.zip
   - cd filetreeCI-*
   - export FILETREE_CI_HOME="$(pwd)"

script: $FILETREE_CI_HOME/run.sh
```