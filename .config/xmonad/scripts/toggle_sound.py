import subprocess

# Get the current default sink
list_sinks = subprocess.Popen(["pacmd", "list-sinks"], stdout=subprocess.PIPE)
default_sink = None
for line in list_sinks.stdout:
    if b"*" in line:
        default_sink = line.split(b":")[1].strip()
        break

# Run pacmd list-sinks command and get output as a byte string
list_sinks = subprocess.check_output(["pacmd", "list-sinks"])

# Decode the output to a string and split it by newline characters
list_sinks = list_sinks.decode().split("\n")

# Initialize an empty list to hold the sink indexes
sink_indexes = []

# Loop through the list_sinks and extract the sink indexes
for line in list_sinks:
    if "index" in line:
        sink_index = int(line.split(":")[-1].strip())
        sink_indexes.append(sink_index)

# Print the sink indexes
print(f"Available sink indexes: {sink_indexes}")

new_sink_index = None

for sink in sink_indexes:
    if int(default_sink) != sink:
        continue

    default_sink_index = sink_indexes.index(int(default_sink))

    if default_sink_index + 2 > len(sink_indexes):
        new_sink_index = sink_indexes[0]
    else:
        new_sink_index = sink_indexes[default_sink_index + 1]

set_sink = subprocess.Popen(
    ["pacmd", "set-default-sink", str(new_sink_index)], stdout=subprocess.PIPE
)
set_sink.wait()
