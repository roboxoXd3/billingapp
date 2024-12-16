// Database constants
const String dbName = 'billing_app.db';
const int dbVersion = 2;

// Table names
const String tableBills = 'bills';
const String tableCompanyDetails = 'company_details';
const String tableFieldConfigs = 'field_configs';

// Field types
const String fieldTypeText = 'text';
const String fieldTypeNumber = 'number';
const String fieldTypeCalculated = 'calculated';

// Bill types
const String billTypeSale = 'Sale';
const String billTypeReturn = 'Return';

// Template types
const String defaultTemplate = 'default';
const String opticalTemplate = 'optical';

// Available templates
const Map<String, String> availableTemplates = {
  defaultTemplate: 'Default Template',
  opticalTemplate: 'Optical Shop Template',
};

// Error messages
const String errorDatabaseInit = 'Error initializing database';
const String errorDatabaseOperation = 'Error performing database operation';
const String errorInvalidInput = 'Invalid input provided';
