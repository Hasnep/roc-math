default: format check test docs examples

format:
    roc format

check:
    roc check src/main.roc
    fd --extension roc . examples --exec roc check

test:
    roc test src/main.roc

docs:
    roc docs src/main.roc

examples:
    fd --extension roc . examples --exec roc run
