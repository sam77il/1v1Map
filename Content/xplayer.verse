using { /Verse.org/Simulation }
using { /Fortnite.com/FortPlayerUtilities }
using { /Fortnite.com/Characters }

xplayer := class():
    Agent : agent
    var InitializedUI : logic = false
    var SelectedCategory : category = category{}

    Initialize():void=
        {}