using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }

game_manager := class(creative_device):
    @editable
    PlayerSpawners : []player_spawner_device = array{}

    @editable
    MaterialItemGranter : item_granter_device = item_granter_device{}

    var xPlayers : []xplayer = array{}

    OnBegin<override>()<suspends>:void=
        InitiatePlayerSpawners()

    InitiatePlayerSpawners():void=
        for (PlayerSpawner : PlayerSpawners):
            PlayerSpawner.SpawnedEvent.Subscribe(OnPlayerSpawned)

    OnPlayerSpawned(Agent : agent):void=
        xPlayer : xplayer = xplayer{Agent := Agent}
        set xPlayers += array{xPlayer}
        MaterialItemGranter.GrantItemIndex(xPlayer.Agent, 0)