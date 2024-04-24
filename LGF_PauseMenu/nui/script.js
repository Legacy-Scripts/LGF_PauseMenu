

$(document).ready(function() {
 
    function updatePauseMenuTitle(nameServer) {
        const titleElement = document.querySelector('.menu-header h1');
        if (titleElement) {
            titleElement.innerText = nameServer;
        }
    }

    $('#map').click(function() {
        console.log("Map clicked");
        $.post(`https://${GetParentResourceName()}/actionPauseMenu`, JSON.stringify('maps'));
        closePauseMenu(); 
    });

    $('#settings').click(function() {
        console.log("Settings clicked");
        $.post(`https://${GetParentResourceName()}/actionPauseMenu`, JSON.stringify('settings'));
        closePauseMenu(); 
    });

    $('#reloadButton').click(function() {
        var link = 'https://discord.gg/wd5PszPA2p'; 
        var inputElement = document.createElement('input');
        inputElement.setAttribute('value', link);
        document.body.appendChild(inputElement);
        inputElement.select();
        document.execCommand('copy');
        document.body.removeChild(inputElement);
        var notification = document.createElement('div');
        notification.classList.add('notification');
        var icon = document.createElement('i');
        icon.classList.add('fas', 'fa-check-circle');
        var text = document.createElement('span');
        text.innerText = "Copied Text Successfully";
        var line = document.createElement('hr');
        var progress = document.createElement('div');
        progress.classList.add('progress');
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
        console.log("Quit clicked");
        openConfirmationPopup("Are you sure you want to exit?", 'quit', function() {
            closePauseMenu(); 
        });
    });

    $('#relog').click(function() {
        console.log("Relog clicked");
        openConfirmationPopup("Are you sure you want to relog?",'relog' , function() {
            closePauseMenu(); 
        });
    });

    window.addEventListener('message', function(event) {
        let data = event.data;
        if (data.action === 'showPauseMenu') {
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
        document.querySelector('.data-grid div:nth-child(1) p:nth-child(1)').innerText = 'Name: ' + playerData.name;
        document.querySelector('.data-grid div:nth-child(1) p:nth-child(2)').innerText = 'Job: ' + playerData.job;
        document.querySelector('.data-grid div:nth-child(2) p:nth-child(1)').innerText = 'Cash: $' + playerData.cash;
        document.querySelector('.data-grid div:nth-child(2) p:nth-child(2)').innerText = 'Group: ' + playerData.group;
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
            playerNameElement.innerText = 'Name: ' + playerName;
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
    
    function openConfirmationPopup(message,action, callback) {
      tipo = action
      console.log(tipo)
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
        $('#player-identifier').css({
            'filter': 'blur(1.8px)',
            'cursor': 'pointer',
            'position': 'relative' 
        }).append('<span id="show-text">Show</span><i class="fas fa-eye-slash" id="eye-icon"></i>');
        
        $('#player-identifier').click(function() {
            if ($(this).css('filter') === 'blur(1.8px)') {
                $(this).css('filter', 'none');
            } else {
                $(this).css('filter', 'blur(1.8px)');
            }
        });
    });
});
