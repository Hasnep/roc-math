default: format check test

format:
    roc format

check:
    roc check src/main.roc

test:
    roc test src/main.roc

docs:
    roc docs src/main.roc
