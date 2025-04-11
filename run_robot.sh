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
policy=DDPG                      # RL model to utilize
lr=5e-4                          # learning rate
d_kl_c=0.05                      # kl divergence coefficient
bs=256                           # batch size
train_num=5                      # number of training environments
test_num=50                      # number of testing environments
maxsteps=140                     # max steps per an agent can execute in a single episode
task=tasks.RobotArmReach-RARG-GI # task name
qh_dim=128                       # qnet hidden dimension
epochs=40

if [ "$debug" = "True" ]; then
    train_n=2
    test_n=2
else
    train_n=10
    test_n=100
fi

# ===== classical SAC, no subgoal =====
for ((i = 1; i <= $nt; i++)); do
    content=$(url_encode "$extra SAC ($i/$nt) @$machine_name started")
    python ./goal-reducer-reimplementation/run_robot_arm.py \
        --seed $((i + seed_offset)) \
        train \
        -e $task \
        --policy $policy \
        --max-steps $maxsteps \
        --extra $extra \
        --training-num $train_num \
        --test-num $test_num \
        --epochs 15 \
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

# ===== GOLSAv2 w RL: GR+SAC =====
for ((i = 1; i <= $nt; i++)); do
    content=$(url_encode "$extra GR w/ RL ($i/$nt) @$machine_name started")
    python ./goal-reducer-reimplementation/run_robot_arm.py \
        --seed $((i + seed_offset)) \
        train \
        -e $task \
        --policy $policy \
        --max-steps $maxsteps \
        --extra $extra \
        --training-num $train_num \
        --test-num $test_num \
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
