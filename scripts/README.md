# Scripts!

## Make a script executable

```
chmod +x [scriptname.sh]
```

## [restart_all.sh](restart_all.sh)

'restart_all.sh' essentially goes through every single docker container, kills it, and then starts it up again. It then displays the status of the Fail2Ban daemon and all docker containers.

To execute:
```
./restart_all.sh

```

## [down_all.sh](down_all.sh)

'down_all.sh' goes through through every single docker container and kills it.

To execute:
```
./down_all.sh
```