import os

off_set = 3
node_number = 10
cabinate_number = 1
interfaces = ["eth0"]

for i in range(10):
	
    old_name = "compute-{c}-{n}".format(c=cabinate_number, n=i+off_set)
    new_name = "compute-{c}-{n}".format(c=cabinate_number, n=i)
    names = {"old": old_name, "new": new_name}
    if i < off_set:
        os.system("rocks remove host {old}".format(**names))
    print "Resetting {old} to {new}".format(**names)
    os.system("rocks set host name {old} {new}".format(**names))
    for inter in interfaces:
	os.system("rocks set host interface name {old} {int} {new}".format(old=names["old"], new=names["new"], int=inter)
    os.system("rocks set host rank {new} {r}".format(new=names["new"], r=i))
    os.system("rocks sync config")
    os.system("rocks sync host network {new}".format(**names))
    os.system('ssh {new} "shutdown -r now"'.format(**names))

