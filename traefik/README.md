# Setting up Traefik

[Traefik Documentation](https://doc.traefik.io/traefik/)

Create and grant acme.json 600 permissions:

```
touch acme.json
chmod 600 acme.json
```

To run container:
```
docker compose up -d
```