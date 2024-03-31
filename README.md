# Шаблон для настройки рабочего пространства для проекта odoo

Структура каталога проекта:

```
main_project_folder
  ├── .vscode
    ├── каталог с настройками рабочего пространства
  ├── .devcontainer
    ├── каталог с настройками dev-контейнера
  ├── simbioz_repo
    ├── каталоги репозитария сборки simbioz
  ├── client_addons
    ├── каталоги дополнительных модулей
  ├── docker
    ├── тут файл Dockerfile для формирования образа odoo
  ├── varlib
    ├── каталог для filestore odoo и для хранения сессий. Очень важно проверить доступы к этому каталогу пользователю докера
  └── conf
    ├── каталог с конфигурационными файлами
```

В каталог `simbioz_repo` нужно клонировать репозиторий именно сборки (AMS, CRMS и т.д).

### Для AMS-проекта клонируем так:

```bash
cd main_project_folder/simbioz_repo
git clone --recurse-submodules git@gitlab.simbioz.com.ua:simbioz_dev/oms.git .
git submodule foreach -q --recursive 'branch="$(git config -f $toplevel/.gitmodules submodule.$name.branch)"; git checkout $branch'
git submodule update --recursive --remote
```

### Для проекта CRMS клонируем так:

```bash
cd main_project_folder/simbioz_repo
git clone --recurse-submodules git@gitlab.simbioz.com.ua:simbioz_dev/sbe.git .
git submodule foreach -q --recursive 'branch="$(git config -f $toplevel/.gitmodules submodule.$name.branch)"; git checkout $branch'
git submodule update --recursive --remote
```

### Для проекта GMS клонируем так:

```bash
cd main_project_folder/simbioz_repo
git clone --recurse-submodules git@gitlab.simbioz.com.ua:simbioz_dev/gms.git .
git submodule foreach -q --recursive 'branch="$(git config -f $toplevel/.gitmodules submodule.$name.branch)"; git checkout $branch'
git submodule update --recursive --remote
```

Также в этот же каталог подключаются другие модули сборки, которые изначально не входили в поставку.
_Подключение модулей к сборке - отдельная тема, которая не касается этого документа._

В каталог `client_addons` клонируется репозитарий с модулями для конкретного клиента. В эту
папку можно склонировать несколько репозитариев и разложить их по подпапкам. <br/>

Обязательно нужно убедиться, что каталог varlib доступен для записи пользователя, под которым все работает в докере. <br/>

В Dockerfile указано ID пользователя и группы 1000. Есть два варианта решения проблемы с доступом к папке:

1. Дать доступ на запись всем пользователям и группам (`chmod 777 varlib`)
2. Определить ID пользователя под которым запускается докер (текущий пользователь системы обычно) и в Dockerfile для создаваемого пользователя указать эти ID.

Вся настройка рабочего пространства для проекта настроена именно на эту структуру каталогов. Если нужно поменять структуру - нужно будет исправить настройки рабочего пространства.

## Порядок работы с репозитарием

1. Склонировать репозитарий
2. Удалить из него папку .git (т.е. просто отключить отслеживание изменений, т.к. мы будем клонировать другие репозитарии в папки и нам нет смысла что-то тут отслеживать)
3. Из папок simbioz_repo и client_addons удалить файл README.md (он нужен только для описания содержимого папки)
4. В папку simbioz_repo склонировать репозитарий сборки (см. выше)
5. В папку client_addons склонировать репозитарий с модулями клиента (если это разработка для клиента)
6. Открыть каталог в IDE
7. Провести настройку путей к модулям odoo `conf/odoo-server.conf` (см. комментарии в самом файле)
8. Для работы с vscode нужно дополнительно настроить файлы:
   - `.vscode/settings.json`
     - задать параметр `odooProjectName` - название проекта (без пробеллов и кириллицы!!)
     - задать параметр `hostOdooRoot` - полный путь к папке проекта (например, `/home/user/projects/odoo/ams`)

### ВАЖНО!

1. Работа в VSCode подразумевает использование расширения Dev Containers. Перед началом работы убедитесь, что установлено расширение [Remote Development](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.vscode-remote-extensionpack)
2. При открытии каталога в VSCode он предложит открыть сразу в dev-container
   ![image]:(/docs/2024-03-31_17-44.png)

   Не нужно открывать контейнер ДО выполнения всех настроек. Он все равно не запустится, т.к. не сможет сформировать Docker-контейнер. Ну и потом могут вылезти еще какие-то проблемы с настройками в дальнейшем.
