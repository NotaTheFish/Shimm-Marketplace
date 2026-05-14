# State machines

Сделка: см. `DealState` в `prisma/schema.prisma` и `apps/deal-room-bot/src/state-machine/`. Все переходы должны проходить через политику/автомат; не допускать «тихих» обходов из handlers.
