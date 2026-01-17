// main.gs - Главный скрипт для Google Таблицы "Home Budget"

function onOpen() {
  var ui = SpreadsheetApp.getUi();
  ui.createMenu('📊 Home Budget')
    .addItem('Create Events Sheet', 'createEventsSheet')
    .addItem('Add Initial Data', 'addInitialData')
    .addSeparator()
    .addItem('Show Help', 'showHelp')
    .addToUi();
}

function createEventsSheet() {
  var ss = SpreadsheetApp.getActiveSpreadsheet();
  
  // Удаляем старый лист Events если есть
  var oldSheet = ss.getSheetByName('Events');
  if (oldSheet) {
    ss.deleteSheet(oldSheet);
  }
  
  // Создаем новый лист Events
  var eventsSheet = ss.insertSheet('Events');
  
  // Заголовки колонок
  var headers = [
    'ID', 
    'Timestamp', 
    'Type', 
    'Amount', 
    'Account_ID', 
    'Reference_ID', 
    'Target_ID', 
    'Category', 
    'Description', 
    'Status'
  ];
  
  // Записываем заголовки
  eventsSheet.getRange(1, 1, 1, headers.length).setValues([headers]);
  
  // Форматируем заголовки
  var headerRange = eventsSheet.getRange(1, 1, 1, headers.length);
  headerRange.setBackground('#4a86e8')
            .setFontColor('white')
            .setFontWeight('bold');
  
  // Настраиваем ширину колонок
  eventsSheet.setColumnWidth(1, 80);   // ID
  eventsSheet.setColumnWidth(2, 180);  // Timestamp
  eventsSheet.setColumnWidth(3, 100);  // Type
  eventsSheet.setColumnWidth(4, 100);  // Amount
  eventsSheet.setColumnWidth(5, 120);  // Account_ID
  eventsSheet.setColumnWidth(6, 120);  // Reference_ID
  eventsSheet.setColumnWidth(7, 120);  // Target_ID
  eventsSheet.setColumnWidth(8, 150);  // Category
  eventsSheet.setColumnWidth(9, 250);  // Description
  eventsSheet.setColumnWidth(10, 100); // Status
  
  // Делаем лист активным
  eventsSheet.activate();
  
  // Сообщение об успехе
  SpreadsheetApp.getUi().alert('✅ Events sheet created successfully!');
}

function addInitialData() {
  var ss = SpreadsheetApp.getActiveSpreadsheet();
  var eventsSheet = ss.getSheetByName('Events');
  
  if (!eventsSheet) {
    SpreadsheetApp.getUi().alert('❌ First create Events sheet via menu!');
    return;
  }
  
  // Пример начальных данных
  var initialData = [
    [
      'EVT001',
      new Date(),
      'INCOME',
      50000,
      'ACC_SALARY',
      '',
      '',
      'Salary',
      'Monthly salary January',
      'CONFIRMED'
    ],
    [
      'EVT002',
      new Date(),
      'EXPENSE',
      15000,
      'ACC_MAIN',
      '',
      '',
      'Rent',
      'Apartment rent January',
      'CONFIRMED'
    ],
    [
      'EVT003',
      new Date(),
      'EXPENSE',
      5000,
      'ACC_MAIN',
      '',
      '',
      'Food',
      'Groceries for week',
      'PENDING'
    ]
  ];
  
  // Добавляем данные начиная со строки 2
  eventsSheet.getRange(2, 1, initialData.length, initialData[0].length)
            .setValues(initialData);
  
  // Автонастройка ширины после добавления данных
  eventsSheet.autoResizeColumns(1, eventsSheet.getLastColumn());
  
  SpreadsheetApp.getUi().alert('✅ Initial data added!');
}

function showHelp() {
  var helpText = "Home Budget Core\n\n" +
                 "1. Create Events Sheet - creates main journal\n" +
                 "2. Add Initial Data - adds sample transactions\n\n" +
                 "Each event represents a financial operation.";
  
  SpreadsheetApp.getUi().alert(helpText);
}

// Вспомогательная функция для тестирования
function testConnection() {
  return "✅ Home Budget Core script is working!";
}

// ===== WEB APP FUNCTIONS FOR METADATA =====
function getTableInfo(e) {
  try {
    const ss = SpreadsheetApp.openById("1Sst29MV_pevphazLNNz3SoBVa_8wwPbcVXfxovao5K4");
    const mode = e.parameter.mode || 'summary';
    const sheetName = e.parameter.sheet;
    
    const result = {
      totalSheets: ss.getNumSheets(),
      sheets: [],
      sheetNames: ss.getSheets().map(s => s.getName())
    };
    
    if (mode === 'sheets') {
      return result;
    }
    
    let sheetsToProcess = [];
    if (sheetName) {
      const sheet = ss.getSheetByName(sheetName);
      if (sheet) sheetsToProcess = [sheet];
    } else {
      sheetsToProcess = mode === 'full' 
        ? ss.getSheets() 
        : ss.getSheets().slice(0, 10);
    }
    
    sheetsToProcess.forEach(sheet => {
      const lastRow = sheet.getLastRow();
      const lastCol = sheet.getLastColumn();
      
      const sheetInfo = {
        name: sheet.getName(),
        rows: lastRow,
        cols: lastCol,
        dataRange: lastRow > 0 && lastCol > 0 
          ? `A1:${String.fromCharCode(64 + lastCol)}${lastRow}`
          : null
      };
      
      if (mode === 'summary') {
        result.sheets.push(sheetInfo);
        return;
      }
      
      if (lastRow > 0 && lastCol > 0) {
        sheetInfo.headers = sheet.getRange(1, 1, 1, Math.min(lastCol, 10))
          .getValues()[0]
          .filter(h => h !== "");
        
        if (lastRow > 1) {
          const sampleRange = sheet.getRange(2, 1, Math.min(lastRow-1, 2), Math.min(lastCol, 5));
          sheetInfo.sampleData = sampleRange.getValues().map(row => 
            row.slice(0, 3).join(" | ") + (row.length > 3 ? "..." : "")
          );
        }
      }
      
      result.sheets.push(sheetInfo);
    });
    
    return result;
  } catch (error) {
    return { error: error.toString() };
  }
}

function doGet(e) {
  const action = e.parameter.action;
  
  if (action === 'info') {
    const info = getTableInfo(e);
    return ContentService
      .createTextOutput(JSON.stringify(info))
      .setMimeType(ContentService.MimeType.JSON);
  }
  
  return ContentService
    .createTextOutput(JSON.stringify({ error: "Unknown action. Use ?action=info" }))
    .setMimeType(ContentService.MimeType.JSON);
}
