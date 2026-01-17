# Модели данных
## Сущность: Event
- id: number
- timestamp: datetime
- type: string (income/expense/transfer/obligation_create/obligation_update/obligation_paid/correction)
- amount: number
- account_id: number
- reference_id: number
- target_id: number
- category: string
- description: string
- status: string (new/applied/cancelled)
