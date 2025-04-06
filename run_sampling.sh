# URL encode function
url_encode() {
    local string="${1}"
    local encoded=""
    local length="${#string}"
    for (( i = 0; i < length; i++ )); do
        local c="${string:i:1}"
        case $c in
            [a-zA-Z0-9.~_-]) 
                encoded+="${c}" ;;
            *) 
                encoded+=$(printf '%%%02X' "'$c") ;;
        esac
    done
    echo "${encoded}"
}

seed_offset=10 # offset for the random seed
nt=1           # number of trials


extra=Demo
analyze=False
debug=False

# ===== comparisson between random, trajectory, and loop removal sampling =====
for ((i = 1; i <= $nt; i++)); do
    content=$(url_encode "$extra DQL ($i/$nt) @$machine_name started")
    python ./goal_reducer_reimplementation/run_sampling_strategies.py \
        --seed $((i + seed_offset)) \
        train
done