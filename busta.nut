// Round types
enum STATE {
    DEFAULT,
    RIFLES,
    PISTOLS,
    AWPS,
    SCOUTS
}

// Initializes variable only once
if (!("gameState" in getroottable()))
{
    ::gameState <- STATE.DEFAULT;
}

// Counter for printing welcome message
if (!("counter" in getroottable()))
{
    ::counter <- 0;
}

// List of possible weapons
weaponList <- [
    "weapon_ak47",
    "weapon_m4a1"
    "weapon_m4a1_silencer",
    "weapon_awp",
    "weapon_deagle"
]

selectedWeapon <- null;

::OnGameEvent_player_say <- function(data) // Event listener for player commands
{  
    local msg = data.text;
    switch (msg)
    {
        // Commmand list
        case ".commands":
            ScriptPrintMessageChatAll("\x01 \x05 ======== LIST OF COMMANDS 1/3 ========");
            ScriptPrintMessageChatAll("\x01 \x03 .r" + "\x01 \x01 - Restarts the game");
            ScriptPrintMessageChatAll("\x01 \x03 .end" + "\x01 \x01 - Ends the warmup");
            ScriptPrintMessageChatAll("\x01 \x03 .kick" + "\x01 \x01 - Kicks the bots");
            ScriptPrintMessageChatAll("\x01 \x03 .exec" + "\x01 \x01 - Executes a series of commands useful for 1v1's");
            ScriptPrintMessageChatAll("\x01 \x03 .pause" + "\x01 \x01 - Pauses the game");
            ScriptPrintMessageChatAll("\x01 \x03 .unpause" + "\x01 \x01- Unpauses the game");
            ScriptPrintMessageChatAll("\x01 \x03 .commands2" + "\x01 \x01 - Opens second page of commands list");
            break;

        // Second page of commands
        case ".commands2":
            ScriptPrintMessageChatAll("\x01 \x05 ======== LIST OF COMMANDS 2/3 ========");
            ScriptPrintMessageChatAll("\x01 \x03 .default" + "\x01 \x01 - Enables default guns only");
            ScriptPrintMessageChatAll("\x01 \x03 .rifles" + "\x01 \x01 - Enables rifles only");
            ScriptPrintMessageChatAll("\x01 \x03 .awps" + "\x01 \x01 - Enables awps only");
            ScriptPrintMessageChatAll("\x01 \x03 .scouts" + "\x01 \x01 - Enables scouts only");
            ScriptPrintMessageChatAll("\x01 \x03 .pistols" + "\x01 \x01 - Enables pistols only");
            ScriptPrintMessageChatAll("\x01 \x03 .egg" + "\x01 \x01 - Scrambles the teams");
            ScriptPrintMessageChatAll("\x01 \x03 .commands3" + "\x01 \x01 - Opens third page of commands list");
            break;

        // Third page of commands
        case ".commands3":
            ScriptPrintMessageChatAll("\x01 \x05 ======== LIST OF COMMANDS 3/3 ========");
            ScriptPrintMessageChatAll("\x01 \x03 .hs" + "\x01 \x01 - Enables headshots only");
            ScriptPrintMessageChatAll("\x01 \x03 !hs" + "\x01 \x01 - Disables headshots only");
            break;

        // Restart game
        case ".r":
            ScriptPrintMessageChatAll("\x01 \x05 Restarting game...");
            SendToConsole("mp_restartgame 1");
            break;

        // Enable headshots only
        case ".hs":
            ScriptPrintMessageChatAll("\x01 \x05 HEADSHOTS ONLY ENABLED");
            SendToConsole("mp_damage_headshot_only 1");
            break;
        
        // Disable headshots only
        case "!hs":
            ScriptPrintMessageChatAll("\x01 \x07 HEADSHOTS ONLY DISABLED");
            SendToConsole("mp_damage_headshot_only 0");
            break;
        
        // End warmup
        case ".end":
            ScriptPrintMessageChatAll("\x01 \x05 Ending warmup...");
            SendToConsole("mp_warmup_end");
            break;
        
        // Execute multiple commands
        case ".exec":
            SendToConsole("sv_cheats 1");
            SendToConsole("sv_infinite_ammo 2");
            SendToConsole("mp_round_restart_delay 3");
            SendToConsole("mp_freezetime 1");
            SendToConsole("mp_match_end_changelevel 0");
            SendToConsole("mp_match_end_restart 1");
            SendToConsole("mp_match_restart_delay 12");
            SendToConsole("mp_maxrounds 30"); 
            SendToConsole("mp_halftime 1"); 
            SendToConsole("mp_overtime_enable 1");
            SendToConsole("sv_cheats 0");
            ScriptPrintMessageChatAll("\x01 \x05 Commands sent");
            break;

        // Pause game
        case ".pause":
            SendToConsole("mp_pause_match");
            break;
        
        // Resume game
        case ".unpause":
            ScriptPrintMessageChatAll("\x01 \x05 MATCH IS LIVE!");
            SendToConsole("mp_unpause_match");
            break;
        
        // Kick bots
        case ".kick":
            SendToConsole("bot_kick");
            ScriptPrintMessageChatAll("\x01 \x05 Kicking bots...");
            break;

        // Scramble teams
        case ".egg":
            ScriptPrintMessageChatAll("\x01 \x05 Scrambling teams...");
            SendToConsole("mp_scrambleteams");
            break;

        // Default guns
        case ".default":
            gameState = STATE.DEFAULT;
            ScriptPrintMessageChatAll("\x01 \x05 DEFAULT GUNS ENABLED");
            SendToConsole("mp_restartgame 1");
            break;

        // Pistols only
        case ".pistols":
            gameState = STATE.PISTOLS;
            ScriptPrintMessageChatAll("\x01 \x05 PISTOLS ONLY ENABLED");
            SendToConsole("mp_restartgame 1");
            break;

        // Rifles only
        case ".rifles":
            gameState = STATE.RIFLES;
            ScriptPrintMessageChatAll("\x01 \x05 RIFLES ONLY ENABLED");
            SendToConsole("mp_restartgame 1");
            break;
        
        // Awps only
        case ".awps":
            gameState = STATE.AWPS;
            ScriptPrintMessageChatAll("\x01 \x05 AWPS ONLY ENABLED");
            SendToConsole("mp_restartgame 1");
            break;
        
        // Scouts only
        case ".scouts":
            gameState = STATE.SCOUTS;
            ScriptPrintMessageChatAll("\x01 \x05 SCOUTS ONLY ENABLED");
            SendToConsole("mp_restartgame 1");
            break;
    }
}.bindenv(this)

function OnPostSpawn() // This function is called at the start of each round
{   
    // Prints this message only once.
    // I hate this. I absolutely hate this. I hate that I had to do it this way, but it was the only way I could get this to work. I don't get why it won't work like I want it to.
    if (counter == 0 || counter == 1)
    {
        ScriptPrintMessageChatAll("\x01 \x05 You can type .commands in chat for a list of commands");
        counter++;
    }

    // Gets a list of all players
    local players = getPlayers();

    // Gives weapons depending on game state
    switch (gameState)
    {
        // Random weapons
        case STATE.DEFAULT:
            local randomNum = RandomInt(0, weaponList.len() - 1);
            selectedWeapon = weaponList[randomNum];
            break;

        // Rifles only
        case STATE.RIFLES:
            local randomNum = RandomInt(0, 2); // First 3 weapons in the list are rifles
            selectedWeapon = weaponList[randomNum];
            break;

        // Pistols only
        case STATE.PISTOLS:
            selectedWeapon = "weapon_usp_silencer";
            break;

        // AWPs only
        case STATE.AWPS:
            selectedWeapon = "weapon_awp";
            break;

        // Scouts only
        case STATE.SCOUTS:
            selectedWeapon = "weapon_ssg08";
            break;
    }

    // Removes weapons from all players, then gives them a specific weapon
    for (local i = 0; i < players.len(); i++)
    {
        removeWeapons(players[i]);
        giveWeapons(players[i], selectedWeapon);
    }
}

function getPlayers() // Returns list of all players on the server
{
    local playerList = [];
    local player = null;

    // Adds human players to the list
    while (player = Entities.FindByClassname(player, "player"))
    {
        playerList.append(player);
    }

    // Adds bot players to the list
    while (player = Entities.FindByClassname(player, "cs_bot"))
    {
        playerList.append(player);
    }

    return playerList;
}

function giveWeapons(player, selectedWeapon) // Gives random weapons to the player
{
    // Creating a game_player_equip entity, which is needed to give players stuff
    local equipper = Entities.CreateByClassname("game_player_equip"); 

    // Things to give to the player
	equipper.__KeyValueFromInt("spawnflags", 5);
    equipper.__KeyValueFromInt("weapon_deagle", 0);
    equipper.__KeyValueFromInt(selectedWeapon, 0);
	equipper.__KeyValueFromInt("weapon_knife", 0);

    // Gives kevlar + helmet unless pistols only is on
    if (gameState != STATE.PISTOLS)
    {
        equipper.__KeyValueFromInt("item_assaultsuit", 0 );
    }
	else
    {
        equipper.__KeyValueFromInt("item_kevlar", 0 );
    }

    equipper.ValidateScriptScope();

    // Give things to the player, then destroy the game_player_equip
    EntFireByHandle(equipper, "Use", "", 0, player, null);
    EntFireByHandle(equipper, "Kill", "", 0.1, null, null);
}

function removeWeapons(player) // Removes all the weapons from the player
{
    local weapon = null;

    while (weapon = Entities.FindByClassname(weapon, "weapon_*"))
    {
        if (weapon.GetOwner() == player)
        {
            weapon.Destroy();
        }
    }
}

/* Different chat colors

ScriptPrintMessageChatAll("\x01 \x01 = White");
ScriptPrintMessageChatAll("\x01 \x02 = Dark Red");
ScriptPrintMessageChatAll("\x01 \x03 = Purple");
ScriptPrintMessageChatAll("\x01 \x04 = Dark Green");
ScriptPrintMessageChatAll("\x01 \x05 = Moss Green");
ScriptPrintMessageChatAll("\x01 \x06 = Lime Green");
ScriptPrintMessageChatAll("\x01 \x07 = Light Red");

*/