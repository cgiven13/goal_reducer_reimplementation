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
nt=5           # number of trials


extra=Demo
analyze=False
debug=False

# first run 11
lr=5e-4                          # learning rate
d_kl_c=0.05                      # kl divergence coefficient
bs=256                           # batch size
agv=13                           # agent view size
size=19                          # environment size
shape=${size}x${size}            # environment shape
maxsteps=140                     # max steps per an agent can execute in a single episode
task=tasks.TVMGFR-$shape-RARG-GI # task name
qh_dim=128                       # qnet hidden dimension
epochs=40

if [ "$debug" = "True" ]; then
    train_n=2
    test_n=2
else
    train_n=10
    test_n=100
fi

# ===== classical DQL, no subgoal =====
for ((i = 1; i <= $nt; i++)); do
    content=$(url_encode "$extra DQL ($i/$nt) @$machine_name started")
    python ./goal-reducer-reimplementation/run_gridworld.py \
        --seed $((i + seed_offset)) \
        train \
        -e $task \
        --policy DQL \
        --agent-view-size $agv \
        --max-steps $maxsteps \
        --extra $extra \
        --epochs 10 \
        --lr $lr \
        --d-kl-c $d_kl_c \
        --batch-size $bs \
        --subgoal-on False \
        --planning True \
        --qh-dim $qh_dim \
        --analyze $analyze \
        --sampling-strategy 4 \
        --debug $debug || exit 1
done

# ===== GOLSAv2 w RL: GR+DQL =====
for ((i = 1; i <= $nt; i++)); do
    content=$(url_encode "$extra GR w/ RL ($i/$nt) @$machine_name started")
    python ./goal-reducer-reimplementation/run_gridworld.py \
        --seed $((i + seed_offset)) \
        train \
        -e $task \
        --policy DQLG \
        --agent-view-size $agv \
        --max-steps $maxsteps \
        --extra $extra \
        --epochs 10 \
        --lr $lr \
        --d-kl-c $d_kl_c \
        --batch-size $bs \
        --subgoal-on True \
        --planning True \
        --qh-dim $qh_dim \
        --analyze $analyze \
        --sampling-strategy 4 \
        --debug $debug || exit 1

done

# ===== GOLSAv2: GR =====
for ((i = 1; i <= $nt; i++)); do
    content=$(url_encode "$extra GR w/ RL ($i/$nt) @$machine_name started")
    python ./goal-reducer-reimplementation/run_gridworld.py \
        --seed $((i + seed_offset)) \
        train \
        -e $task \
        --policy NonRL \
        --agent-view-size $agv \
        --max-steps $maxsteps \
        --extra $extra \
        --epochs 10 \
        --lr $lr \
        --d-kl-c $d_kl_c \
        --batch-size $bs \
        --subgoal-on True \
        --planning True \
        --qh-dim $qh_dim \
        --analyze $analyze \
        --sampling-strategy 4 \
        --debug $debug || exit 1

done