use framework "Foundation"use scripting additions-- Функция чтения JSON on readJSONFile(jsonPath)	set jsonURL to current application's NSURL's fileURLWithPath:jsonPath	set jsonData to current application's NSData's dataWithContentsOfURL:jsonURL	set {parsedJSON, errorRef} to current application's NSJSONSerialization's JSONObjectWithData:jsonData options:0 |error|:(reference)	if parsedJSON is missing value then		set errorMsg to errorRef's localizedDescription() as text		error "Ошибка парсинга JSON: " & errorMsg	end if	return parsedJSON as recordend readJSONFile-- Загрузка JSONset jsonFilePath to POSIX path of "/Users/zey/Documents/notes.json"set jsonData to readJSONFile(jsonFilePath)-- Забираем параметрыset modemPass to modem_pass of jsonDataset local_ip to loc_ip_adresses of jsonDatatell application "Safari"	activate	-- Открываем страницу входа	set newTab to make new document	set URL of newTab to "http://192.168.0.1/index.html#login"	-- delay 1		-- Логин (автоматический ввод пароля)	do JavaScript "
        (function(){
            var passwordField = document.querySelector('#txtPwd');
            var loginButton   = document.querySelector('#btnLogin');
            if (passwordField && loginButton) {
                passwordField.focus();
                passwordField.value = '" & modemPass & "';
                passwordField.dispatchEvent(new Event('input', { bubbles: true }));
                passwordField.dispatchEvent(new Event('change', { bubbles: true }));
                console.log('Пароль установлен.');
                loginButton.focus();
                loginButton.click();
                console.log('Кнопка логина нажата.');
            } else {
                console.error('Не найдены необходимые элементы для логина.');
            }
        })();
	" in document 1	delay 1		-- Переход по вкладкам: Settings, Firewall, Port Mapping, выбор Enable	do JavaScript "
        (function(){
            var settingsTab = document.querySelector('a[href=\"#router_setting\"]');
            if (settingsTab) {
                settingsTab.click();
                console.log('Перешли на вкладку Settings.');
            } else {
                console.error('Не найдена вкладка Settings.');
            }
        })();
	" in document 1	delay 1		do JavaScript "
        (function(){
            var firewallTab = document.querySelector('a[href=\"#firewall\"]');
            if (firewallTab) {
                firewallTab.click();
                console.log('Перешли на вкладку Firewall.');
            } else {
                console.error('Не найдена вкладка Firewall.');
            }
        })();
	" in document 1	delay 1		do JavaScript "
        (function(){
            var portMappingTab = document.querySelector('a[href=\"#port_map\"]');
            if (portMappingTab) {
                portMappingTab.click();
                console.log('Перешли на вкладку Port Mapping.');
            } else {
                console.error('Не найдена вкладка Port Mapping.');
            }
        })();
	" in document 1	delay 1		do JavaScript "
        (function(){
            var enableRadio = document.querySelector('input#mapEnable');
            if (enableRadio) {
                if (!enableRadio.checked) {
                    enableRadio.checked = true;
                    enableRadio.dispatchEvent(new Event('change', { bubbles: true }));
                    console.log('Выбрана опция Enable.');
                } else {
                    console.log('Опция Enable уже выбрана.');
                }
            } else {
                console.error('Не найден элемент radio с id mapEnable.');
            }
        })();
	" in document 1	-- delay 1		-- Заполнение полей формы без нажатия кнопки Apply	do JavaScript "
    (function(){
        // Заполнение поля Source Port
        var sourcePortEl = document.getElementById('txtSourcePort');
        if (sourcePortEl) {
            sourcePortEl.value = '5900';
            sourcePortEl.dispatchEvent(new Event('input', { bubbles: true }));
            sourcePortEl.dispatchEvent(new Event('change', { bubbles: true }));
            console.log('Поле Source Port заполнено значением 5900.');
        } else {
            console.error('Поле Source Port не найдено.');
        }
        
        // Заполнение поля Destination IP
        var destIpEl = document.getElementById('txtDestIpAddress');
        if (destIpEl) {
            destIpEl.value = '" & local_ip & "';
            destIpEl.dispatchEvent(new Event('input', { bubbles: true }));
            destIpEl.dispatchEvent(new Event('change', { bubbles: true }));
            destIpEl.dispatchEvent(new KeyboardEvent('keyup', { bubbles: true, key: 'Enter' }));
            destIpEl.dispatchEvent(new Event('blur', { bubbles: true }));
            console.log('Поле Destination IP заполнено значением: ' + '" & local_ip & "');
        } else {
            console.error('Поле Destination IP не найдено.');
        }
        
        // Заполнение поля Destination Port
        var destPortEl = document.getElementById('txtDestPort');
        if (destPortEl) {
            destPortEl.value = '5900';
            destPortEl.dispatchEvent(new Event('input', { bubbles: true }));
            destPortEl.dispatchEvent(new Event('change', { bubbles: true }));
            console.log('Поле Destination Port заполнено значением 5900.');
        } else {
            console.error('Поле Destination Port не найдено.');
        }
        
        // Заполнение поля Protocol
        var protocolEl = document.getElementById('protocol');
        if (protocolEl) {
            protocolEl.value = 'TCP+UDP';
            protocolEl.dispatchEvent(new Event('change', { bubbles: true }));
            console.log('Поле Protocol заполнено значением TCP+UDP.');
        } else {
            console.error('Поле Protocol не найдено.');
        }
        
        // Заполнение поля Comment
        var commentEl = document.getElementById('txtComment');
        if (commentEl) {
            commentEl.value = 'SRV_VNC';
            commentEl.dispatchEvent(new Event('input', { bubbles: true }));
            commentEl.dispatchEvent(new Event('change', { bubbles: true }));
            console.log('Поле Comment заполнено значением SRV_VNC.');
        } else {
            console.error('Поле Comment не найдено.');
        }
            console.log('Форма заполнена, данные:', formData);
        alert('Форма заполнена:\\n' + JSON.stringify(formData, null, 2));
    })();
	" in document 1end tell
