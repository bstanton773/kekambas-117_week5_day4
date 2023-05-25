# Create a function that given a list which represents street lights given
# as a parameter(l_street), determine if an outage has occurred.
# A street with a total number of "F" greater than or equal to 2 returns "Outage",
# anything below returns "Power"
# Example Input: [ 'T', 'F', 'F', 'F' ]             
# Example Output: "Outage"

def solution(lights):
    num_out = 0
    for light in lights:
        if light == 'F':
            num_out += 1
            if num_out >= 2:
                return 'Outage'
    return 'Power'
