// scripts/core/event.js
/**
 * Модель события для Home Budget
 * @typedef {Object} Event
 * @property {string} id - Уникальный идентификатор
 * @property {Date} timestamp - Время события
 * @property {string} type - Тип: income, expense, transfer
 * @property {number} amount - Сумма
 * @property {string} account_id - Идентификатор счёта
 * @property {string} reference_id - Ссылка на другое событие
 * @property {string} target_id - Целевой объект
 * @property {string} category - Категория
 * @property {string} description - Описание
 * @property {string} status - Статус: pending, completed, cancelled
 */

/**
 * Создание события с валидацией
 * @param {Object} data - Данные события
 * @returns {Event} Валидированное событие
 */
function createEvent(data) {
  const event = {
    id: data.id || generateId(),
    timestamp: data.timestamp ? new Date(data.timestamp) : new Date(),
    type: data.type || 'unknown',
    amount: parseFloat(data.amount) || 0,
    account_id: data.account_id || '',
    reference_id: data.reference_id || '',
    target_id: data.target_id || '',
    category: data.category || 'uncategorized',
    description: data.description || '',
    status: data.status || 'pending'
  };
  
  validateEvent(event);
  return event;
}

/**
 * Валидация события
 * @param {Event} event 
 */
function validateEvent(event) {
  if (!event.id) throw new Error('Event must have id');
  if (!event.timestamp) throw new Error('Event must have timestamp');
  if (!['income', 'expense', 'transfer', 'unknown'].includes(event.type)) {
    throw new Error(`Invalid event type: ${event.type}`);
  }
  if (typeof event.amount !== 'number') {
    throw new Error('Amount must be a number');
  }
}

/**
 * Генерация уникального ID
 * @returns {string}
 */
function generateId() {
  return 'event_' + Date.now() + '_' + Math.random().toString(36).substr(2, 9);
}

// Экспорт для использования в Node.js и браузере
if (typeof module !== 'undefined' && module.exports) {
  module.exports = { createEvent, validateEvent, generateId };
}
