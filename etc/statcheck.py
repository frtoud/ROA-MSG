import re
import statistics
from pathlib import Path
import json
import os


current_mod_folder = "0"

def _find_stats(stats, text):
    for stat in stats:
        _find_stat(stats[stat], text)
    return
    
def _find_stat(stat, text):
    search_str = stat["name"] + "\s*="
    match = re.search(search_str, text)
    #stat["list"].append(match)
    if match:
        subtxt = re.split("[^-\d\.\s\n]", text[match.span()[1]:])[0]
        try:
           stat["list"].append(float(subtxt))
        except ValueError:
           print(stat["name"] + " was not a float, " + current_mod_folder)
    return

    
def _init_stat(name):
    return { "name":name, "q":[0,0,0,0,0,0,0,0], "list":[] }

if __name__ == "__main__":

    
    stat_names = "walk_speed walk_accel walk_turn_time char_height initial_dash_speed gravity_speed max_jump_hsp dash_stop_percent dash_speed dash_turn_accel dash_stop_percent ground_friction moonwalk_accel leave_ground_max max_jump_hsp air_max_speed jump_change air_friction air_accel prat_fall_accel max_fall fast_fall gravity_speed hitstun_grav jump_speed short_hop_speed djump_speed max_djumps walljump_hsp walljump_vsp land_time prat_land_time wave_friction wave_land_adj roll_forward_max roll_backward_max air_dodge_speed techroll_speed"
    stat_names = stat_names.split()
    
    stats = dict()
    for stat in stat_names:
        stats[stat] = _init_stat(stat)


    mods = os.scandir() #assumd to be in the subscriptions folder
    for m in mods:
        path = os.path.join(m.path, "scripts/init.gml")
        current_mod_folder = m.path
        if m.is_dir() and os.path.exists(path):
    	    
            text = Path(path).read_text(errors="ignore")
            _find_stats(stats, text)
    
    #statistical analysis
    #Q values:
    #Q0: min Q1: 1st quartile Q2: median Q3: 3rd Quartile Q4: Max Q5: average Q6: Std dev Q7:mode
    for stat in stats:
       s = stats[stat]
       l = s["list"]
       q = s["q"]
       l.sort()
       quantiles = statistics.quantiles(l, n=4)
       q[0] = l[0]
       q[1] = quantiles[0]
       q[2] = statistics.median(l)
       q[3] = quantiles[2]
       q[4] = l[-1]
       q[5] = statistics.mean(l)
       q[6] = statistics.stdev(l)
       q[7] = statistics.mode(l)
       
       s["list"] = list(set(l))
       s["list"].sort()
    
    #final output
    with open("out.json", "w") as file:
        json.dump(stats, file)
           
    input("Press Enter to close.")
