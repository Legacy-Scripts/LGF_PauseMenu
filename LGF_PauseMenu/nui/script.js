const debug = false;
var locale = {};
var discordInvite = "https://discord.gg/wd5PszPA2p";

function debugPrint() {
    if (debug) {console.log(arguments)};
}

function updateText(localeData) {

    locale = localeData;

    document.querySelector('#show-text').innerText = locale.mainpage.show;

    document.querySelector('#map-h2').innerText = locale.mainpage.map.title;
    document.querySelector('#map-h2').innerText = locale.mainpage.map.description;
    
    document.querySelector('#settings-h2').innerText = locale.mainpage.settings.title;
    document.querySelector('#settings-p').innerText = locale.mainpage.settings.description;
    
    document.querySelector('#exit-h2').innerText = locale.mainpage.exit.title;
    document.querySelector('#exit-p').innerText = locale.mainpage.exit.description;
    
    document.querySelector('#relog-h2').innerText = locale.mainpage.relog.title;
    document.querySelector('#relog-p').innerText = locale.mainpage.relog.description;
    
    document.querySelector('#rules-h2').innerText = locale.mainpage.rules.title;
    
    const rulesDiv = document.querySelector('#rules-div');
    rulesDiv.innerHTML = "";
    locale.mainpage.rules.rules.forEach(item => {
        const txt = document.createElement("p");
        txt.innerHTML = `• ${item}`;

        rulesDiv.appendChild(txt)
    })

    document.querySelector('#playerdata-h2').innerText = locale.mainpage.playerdata.title;

    document.querySelector('#resume-p').innerText = locale.mainpage.resume;

    document.querySelector('#confirmAction').innerText = locale.confirm.yes;
    document.querySelector('#cancelAction').innerText = locale.confirm.no;
}

$(document).ready(function() {
 
    function updatePauseMenuTitle(nameServer) {
        const titleElement = document.querySelector('.menu-header h1');
        if (titleElement) {
            titleElement.innerText = nameServer;
        }
    }

    $('#map').click(function() {
        debugPrint("Map clicked");
        $.post(`https://${GetParentResourceName()}/actionPauseMenu`, JSON.stringify('maps'));
        closePauseMenu(); 
    });

    $('#settings').click(function() {
        debugPrint("Settings clicked");
        $.post(`https://${GetParentResourceName()}/actionPauseMenu`, JSON.stringify('settings'));
        closePauseMenu(); 
    });

    $('#reloadButton').click(function() {
        var inputElement = document.createElement('input');
        inputElement.setAttribute('value', discordInvite);
        inputElement.select();

        document.body.appendChild(inputElement);
        document.execCommand('copy');
        document.body.removeChild(inputElement);

        var icon = document.createElement('i');
        icon.classList.add('fas', 'fa-check-circle');

        var text = document.createElement('span');
        text.innerText = locale.notification.copy_success;

        var line = document.createElement('hr');

        var progress = document.createElement('div');
        progress.classList.add('progress');

        var notification = document.createElement('div');
        notification.classList.add('notification');
        notification.appendChild(icon);
        notification.appendChild(text);
        notification.appendChild(line);
        notification.appendChild(progress);

        document.body.appendChild(notification);

        setTimeout(function() {
            notification.classList.add('hide');
            setTimeout(function() {
                document.body.removeChild(notification);
            }, 500); 
        }, 4000);
    });

    $('#quit').click(function() {
        debugPrint("Quit clicked");
        openConfirmationPopup(locale.confirm.exit_confirmation, 'quit', function() {
            closePauseMenu(); 
        });
    });

    $('#relog').click(function() {
        debugPrint("Relog clicked");
        openConfirmationPopup(locale.confirm.relog_confirmation,'relog' , function() {
            closePauseMenu(); 
        });
    });

    window.addEventListener('message', function(event) {
        let data = event.data;
        if (data.action === 'showPauseMenu') {

            discordInvite = data?.discordInvite ? data.discordInvite : discordInvite;

            updateUI(data.DataPlayer);
            openPauseMenu();
            updatePauseMenuTitle(data.nameServer); 
        }
    });

    function updateTime() {
        const currentTimeElement = document.getElementById('current-time');
        if (currentTimeElement) {
            currentTimeElement.innerText = ReturnTime();
        }
    }

    function ReturnTime() {
        const now = new Date();
        let hours = now.getHours();
        const minutes = now.getMinutes().toString().padStart(2, '0');
        const ampm = hours >= 12 ? 'PM' : 'AM';
        hours = hours % 12;
        hours = hours ? hours : 12; 
        const formattedTime = `${hours}:${minutes} ${ampm}`;
        return formattedTime;
    }

    function updateUI(playerData) {
        document.querySelector('.data-grid div:nth-child(1) p:nth-child(1)').innerText = locale.mainpage.playerdata.name + ': ' + playerData.name;
        document.querySelector('.data-grid div:nth-child(1) p:nth-child(2)').innerText = locale.mainpage.playerdata.job + ': ' + playerData.job;
        document.querySelector('.data-grid div:nth-child(2) p:nth-child(1)').innerText = locale.mainpage.playerdata.cash + ': ' + locale.mainpage.playerdata.currency + playerData.cash;
        document.querySelector('.data-grid div:nth-child(2) p:nth-child(2)').innerText = locale.mainpage.playerdata.group + ': ' + playerData.group;
        updatePlayerID(playerData.playerID);
        updatePlayerName(playerData.playerName);
        updatePlayerIdentifier(playerData.identifier);
    }

    function updatePlayerID(playerID) {
        const playerIDElement = document.getElementById('player-id');
        if (playerIDElement) {
            playerIDElement.innerText = 'ID: ' + playerID;
        }
    }

    function updatePlayerName(playerName) {
        const playerNameElement = document.getElementById('player-name');
        if (playerNameElement) {
            playerNameElement.innerText = playerName;
        }
    }

    function updatePlayerIdentifier(char) {
        const identifierElement = document.getElementById('player-identifier');
        if (identifierElement) {
            identifierElement.innerText = char;
        }
    }

    function openPauseMenu() {
        document.body.style.display = 'block';
        document.addEventListener('keydown', function(e) {
            if (e.key === 'Escape') {
                closePauseMenu();
            }
        });
    }

    function closePauseMenu() {
        document.body.classList.add('closing');
        fetch(`https://${GetParentResourceName()}/closePauseMenu`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json; charset=UTF-8',
            },
            body: JSON.stringify({}),
        })
        .then(response => response.json())
        .then(data => {
            setTimeout(() => {
                document.body.style.display = 'none';
                document.body.classList.remove('closing');
            }, 500); 
        })
        .catch(error => {
            console.error('Error calling server:', error);
        });
    }
    
    function openConfirmationPopup(message, action, callback) {
      tipo = action
      debugPrint(tipo)
        const popupContent = document.querySelector('.confirmation-popup .popup-content p');
        popupContent.innerText = message;
        $('#confirmationPopup').show();
        $('#overlay').show();

        $('#confirmAction').click(function() {
            $.post(`https://${GetParentResourceName()}/actionPauseMenu`, JSON.stringify(tipo));
            callback();
            tipo = null
            $('#confirmationPopup').hide();
            $('#overlay').hide();
        });

        $('#cancelAction').click(function() {
            $('#confirmationPopup').hide();
            $('#overlay').hide();
        });
    }

    setInterval(updateTime, 1000);

    $(document).ready(function() {

        fetch(`https://${GetParentResourceName()}/getLocale`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json; charset=UTF-8',
            },
            body: JSON.stringify({}),
        })
        .then(response => response.json())
        .then(data => {
            // locale = data.locale;

            updateText(data.locale);
        })
        // .catch(error => {
        //     console.error('Error calling server:', error);
        // });

        $('#player-identifier').css({
            'filter': 'blur(1.8px)',
            'cursor': 'pointer',
            'position': 'relative' 
        });
        
        $('#player-identifier').click(function() {
            if ($(this).css('filter') === 'blur(1.8px)') {
                $(this).css('filter', 'none');
            } else {
                $(this).css('filter', 'blur(1.8px)');
            }
        });
    });
});
