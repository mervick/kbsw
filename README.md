# KBSW - Переключатель языков для линукс дистрибутивов с консоли

Simple keyboard switcher. Make the change a keyboard layout easy from the shell.  
С помощью данной утилиты возможно установить переключение лайота клавиатуры на желаемый язык из консоли. Также с помощью штатных средств ОС возможна установка хоткеев для переключения язков.

### Install - Установка

After downloading file `kbsw.sh` make him exacutable:  
После скачивания файла `kbsw.sh` делаем его исполняемым:
```
chmod +x /path/to/file/kbsw.sh
```

### Usage - Использование

```
kbsw [options]
```
Options:  
Параметры:

```
-h, --help          - Show this help - Справка
-l, --layout=NAME   - Sets keyboard layout - Установка лайота клавиатуры
-s, --switch[=NUM]  - Switches keyboard layouts - Переключение лайота
--show-layouts      - Display all available keyboard layouts - Показать все доступные лайоты
```

## Примеры использования

Пример 1:  
В системе установлено несколько языков, чтобы переключать определенный язык через свою комбинацию клавиш, допустим `ctrl+shift+num1`, `ctrl+shift+num2`, и т.д.  

Нужно сначало ввести в терминале `bash /путь/к/файлу/kbsw.sh --show-layouts` и утилита выведет все лайоты установленных клавиатур, у меня это  
```
[ 'us' 'ru' 'ua' ]
```
После, захожу Параметры системы->Клавиатура->Комбинации клавиш->Дополнительные комбинации и добавляю новые комбинации клавиш с командой `bash /путь/к/файлу/kbsw.sh --layout=ru` для русского языка, `...=ua` для украинского и `...=us` для английского соответственно, для каждой комбинации устанавливаю свою комбинацию клавиш нажатием напротив названия комбинации клавиш.

Пример 2:  
В системе установлены три раскладки: английский, русский и украинский, я хочу через `alt+shift` переключать между собой только первые два, а украинский только по установленному до этого сочетанию клавиш (Пример 1).

Для начала, нужно убрать стандартный переключатель на другой хоткей (я поставил на capslock), а после через комбинации клавиш (смотри выше) установить команду для хоткея `bash /путь/к/файлу/kbsw.sh --switch` (будет переключаться первые два установленных в системе языка между собой, если нужно переключать 3 или более, нужно указать с параметром `--switch=N`, где N - количество языков для переключения), после нужно установить хоткей для комбинации, однако система не разрешит установить сочетание `alt-shift`, поэтому для этого нужно в редакторе `dconf-editor` в разделе `org.gnome.settings-daemon.plugins.media-keys.org.gnome.custom-keybindings`
будут подразделы `custom[0-9]+`, ищем нужный нам подраздел по полю `command`, в поле `binding` устанавливаем значение `<Shift><Alt>`.

## License - Лицензия

LGPLv2
