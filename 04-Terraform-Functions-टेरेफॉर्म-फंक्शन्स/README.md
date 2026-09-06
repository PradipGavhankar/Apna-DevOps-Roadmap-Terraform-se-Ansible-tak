
# Terraform Functions – टेरफॉर्म फंक्शन (Azure Focus)

---

## 🔹 1. हिन्दी में समझें

अब तक हमने एक ही Resource बनाया।

लेकिन वास्तविक प्रोजेक्ट में हमें:

- कई Virtual Machines बनानी होती हैं
- अलग-अलग नाम देने होते हैं
- Environment (Dev / Prod) के अनुसार बदलाव करना होता है

यह सब करने के लिए Terraform में Functions और Expressions का उपयोग किया जाता है।

Functions की सहायता से हम:

- Text बदल सकते हैं
- Multiple resources बना सकते हैं (count and for_each के माध्यम से)
- Conditions लगा सकते हैं
- Code को intelligent बना सकते हैं

Terraform Functions हमें existing values, strings, numbers, lists, maps और objects पर operations perform करने की सुविधा देते हैं।

> 🚀 Terraform Functions सीखने का उद्देश्य HCL code को dynamic, reusable, readable और production-friendly बनाना है।
---

# 🧠 Terraform Function क्या है?

## 🟢 पहले आसान हिन्दी में समझ

Function को एक छोटी machine समझो।

हम उसे input देते हैं:

```text
Input
  ↓
Function
  ↓
Processed Output
```

## 🔹 2. Understand in English

Until now, we created only one resource.

In real-world Azure projects, we often need:

- Multiple virtual machines
- Dynamic naming
- Environment-based configurations

Terraform Functions and Expressions help us:

- Manipulate strings
- Create multiple resources (using count)
- Apply conditions
- Make infrastructure dynamic



Terraform Functions predefined functions होते हैं जिनका उपयोग Terraform configuration में values को process, transform और calculate करने के लिए किया जाता है।

उदाहरण:

```hcl
name = upper("pradip")
```
Output:
```
PRADIP
```
Terraform Functions की मदद से हम:

String को manipulate कर सकते हैं
List को filter/transform कर सकते हैं
Map से values निकाल सकते हैं
Numbers पर calculation कर सकते हैं
Conditional values बना सकते हैं
Files पढ़ सकते हैं
Collections को combine कर सकते हैं
Dynamic resource names बना सकते हैं

## 🔵 English

Terraform functions are built-in functions used to transform, calculate, filter, and manipulate values inside Terraform configuration.

Example:
```
name = upper("pradip")
```
Output:
```
PRADIP
```
Functions help us write:

Dynamic configurations
Reusable Terraform code
Cleaner expressions
Environment-specific configurations
Production-ready Infrastructure as Code
## 🧠 Basic Function Syntax
function_name(argument1, argument2)

Example:
```
upper("terraform")
```
Output:

TERRAFORM

Another example:

length(["dev", "qa", "prod"])

Output:

3

🗺️ Terraform Functions Learning Roadmap
Terraform Functions
│
├── String Functions
│   ├── upper()
│   ├── lower()
│   ├── trim()
│   ├── replace()
│   ├── join()
│   ├── split()
│   └── format()
│
├── Numeric Functions
│   ├── min()
│   ├── max()
│   ├── abs()
│   ├── ceil()
│   └── floor()
│
├── Collection Functions
│   ├── length()
│   ├── concat()
│   ├── distinct()
│   ├── flatten()
│   ├── sort()
│   ├── reverse()
│   ├── contains()
│   └── element()
│
├── Map/Object Functions
│   ├── lookup()
│   ├── merge()
│   ├── keys()
│   └── values()
│
├── Type Conversion Functions
│   ├── tostring()
│   ├── tonumber()
│   ├── tolist()
│   ├── tomap()
│   ├── toset()
│   └── tobool()
│
├── Conditional Functions
│   └── conditional expression
│
├── File Functions
│   ├── file()
│   ├── fileexists()
│   └── templatefile()
│
└── Advanced Functions
    ├── try()
    ├── can()
    ├── coalesce()
    ├── jsonencode()
    └── jsondecode()


## 1️⃣ String Functions

String functions text values के साथ काम करते हैं।

🔹 upper()

String को uppercase में convert करता है।

## 🚀 Input
```
variable "environment" {
  default = "dev"
}

output "environment_upper" {
  value = upper(var.environment)
}
```
## 🚀 Output
```
environment_upper = "DEV"
```
> कहाँ useful है?
- Environment labels
- Naming conventions
- Tags
- Reporting
- Standardized metadata

🔹 lower()

String को lowercase में convert करता है।

## 🚀 Input
```
output "environment_lower" {
  value = lower("PRODUCTION")
}
```
## 🚀 Output
```
environment_lower = "production"
```
> कहाँ useful है?
- Storage account names
- DNS names
- Resource naming standards
- Environment identifiers

🎯 Production Use
- User input cleaning
- Environment names
- Configuration normalization
- Removing unwanted characters

🔹 trim()

String के beginning और ending से unwanted characters हटाने के लिए।

## 🚀 Input
```
output "trimmed_value" {
  value = trim("  terraform  ", " ")
}
```
## 🚀 Output
```
  + trimmed_value      = "terraform"
```
🔹 replace()
### Syntax
```
replace(string, substring, replacement)
```

String के अंदर एक value को दूसरी value से replace करता है।
## 🚀 Input
```
output "resource_name" {
  value = replace("pradip-dev-rg", "dev", "prod")
}
```
## 🚀 Output
```
  + resource_name      = "pradip-prod-rg"
```
## 🚀 Input Example
```
variable "resource_name" {
  type = string
}

locals {
  standardized_name = replace(
    upper(var.resource_name),
    "_",
    "-"
  )
}
```
## 🚀 Output
```
PRADIP_PROD_RG
```

🔹 join()

List के elements को एक string में combine करता है। join(separator, list)
### Syntax
```
join(separator, list)
```
## 🚀 Input Example
```
variable "locations" {
  default = ["Pradip", "Dev", "RG"]
}

output "locations" {
  value = join("-", var.locations)
}
```
## 🚀 Output
```
+ locations          = "Pradip-Dev-RG"
```
### 🚀 Production Example – Dynamic Resource Naming
```
variable "application" {
  type = string
}

variable "environment" {
  type = string
}

variable "region" {
  type = string
}

locals {
  resource_name = join("-", [
    var.application,
    var.environment,
    var.region,
    "rg"
  ])
}
```
### Input 
```
application = "payment"
environment = "prod"
region      = "westeurope"
```
### Output
```
payment-prod-westeurope-rg
```
## 🔥 यह production में बहुत useful pattern है।

एक ही naming logic:
```
application-environment-region-resource
```
सभी environments में reuse हो सकता है।

## 🎯 Interview Line

join() combines elements of a list into a single string using a specified separator.

🔹 split()

String को list में convert करता है।

Syntax
```
split(separator, string)
```

```
output "environment_list" {
  value = split("-", "Pradip-Dev-RG")
}
```
## 🚀 Output
```
[
  "Pradip",
  "Dev",
  "RG"
]
```
### 🚀 Production Example

अगर input एक single string में आया:
```
variable "regions" {
  type = string
}
```
Input:
```
"centralindia,westeurope,eastus"
```
Convert:
```
locals {
  region_list = split(",", var.regions)
}
```
Output:
```
[
  "centralindia",
  "westeurope",
  "eastus"
]
```
### 🎯 Production Use
- CSV-style input
- CLI/environment variables
- Configuration parsing
- Converting strings into collections

🔹 format()
### 🟢 हिन्दी

format() template-style string बनाता है।

Example
```
format("%s-%s-%s", "payment", "prod", "vm")
```
Output:
```
payment-prod-vm
```
### 🚀 Production Example
```
locals {
  vm_name = format(
    "%s-%s-%s",
    var.application,
    var.environment,
    "vm"
  )
}
```
Output:
```
payment-prod-vm
```
### 🎯 Production Use
- Standard resource naming
- Structured strings
- IDs
- Tags
- Configuration templates

## 2️⃣ Numeric Functions

Numbers के साथ calculations करने के लिए numeric functions use होते हैं।

🔹 max()

max() सबसे बड़ी value return करता है।
```
max(10, 20, 5, 30)
```
Output:
```
30
```

### 🚀 Production Example

Maximum instance limit:
```
locals {
  max_instances = max(
    var.minimum_instances,
    var.requested_instances
  )
}
```
> Useful for:
- Scaling calculations
- Capacity planning
- Limits
- Resource sizing

🔹 min()

### 🟢 हिन्दी

min() सबसे छोटी value return करता है।
Input:
```
min(10, 20, 5, 30)
```
Output:
```
5
```
## 🚀 Production Example

Resource capacity के लिए minimum value enforce करना:
```
locals {
  minimum_instances = min(
    var.requested_instances,
    10
  )
}
```
अगर:
```
requested_instances = 6
```
Result:
```
6
```
अगर:
```
requested_instances = 15
```
Result:
```
10
```
🔹 abs()

Negative number को positive absolute value में convert करता है।
```
output "absolute_value" {
  value = abs(-100)
}
```
### 🚀 Output
100
🔹 ceil()

Number को ऊपर की तरफ round करता है।
```
output "ceil_value" {
  value = ceil(10.2)
}
```
### 🚀 Output
11
🔹 floor()

Number को नीचे की तरफ round करता है।
```
output "floor_value" {
  value = floor(10.9)
}
```
### 🚀 Output
10
## 3️⃣ Collection Functions

Terraform में List, Set, Tuple आदि collections के साथ काम करने के लिए collection functions बहुत important हैं।

🔹 length()

Collection में कितने elements हैं यह बताता है।
```
variable "environments" {
  default = ["dev", "qa", "prod"]
}

output "environment_count" {
  value = length(var.environments)
}
```
## 🚀 Output
environment_count = 3
🔹 concat()

दो या अधिक lists को combine करता है।
```
variable "frontend" {
  default = ["web1", "web2"]
}

variable "backend" {
  default = ["api1", "api2"]
}

output "servers" {
  value = concat(var.frontend, var.backend)
}
```
### 🚀 Output
[
  "web1",
  "web2",
  "api1",
  "api2"
]
🔹 distinct()

Duplicate values हटाता है।

output "unique_values" {
  value = distinct(["dev", "qa", "dev", "prod", "qa"])
}
### 🚀 Output
[
  "dev",
  "qa",
  "prod"
]
🔹 sort()

List को sort करता है।
```
output "sorted_values" {
  value = sort(["prod", "dev", "qa"])
}
```
### 🚀 Output
[
  "dev",
  "prod",
  "qa"
]
🔹 contains()

Check करता है कि collection में कोई value मौजूद है या नहीं।
```
variable "environments" {
  default = ["dev", "qa", "prod"]
}

output "is_prod_available" {
  value = contains(var.environments, "prod")
}
```
### 🚀 Output
true
🔹 flatten()

Nested lists को single list में convert करता है।
```
variable "subnets" {
  default = [
    ["frontend", "backend"],
    ["database", "management"]
  ]
}

output "all_subnets" {
  value = flatten(var.subnets)
}
```
### 🚀 Output
[
  "frontend",
  "backend",
  "database",
  "management"
]
## 4️⃣ Map Functions

Maps Terraform में key-value pairs store करते हैं।

🔹 lookup()

Map से specific key की value निकालने के लिए।
```
variable "regions" {
  default = {
    dev  = "West Europe"
    prod = "East US"
  }
}

output "dev_region" {
  value = lookup(var.regions, "dev", "Central India")
}
```
### 🚀 Output
dev_region = "West Europe"
🔹 keys()

Key is always string.

Map की सभी keys निकालता है।
```
variable "environment_map" {
  default = {
    dev  = "West Europe"
    qa   = "Central India"
    prod = "East US"
  }
}

output "environment_names" {
  value = keys(var.environment_map)
}
```
🔹 values()
Value is anything.
Map की सभी values निकालता है।
```
output "regions" {
  value = values(var.environment_map)
}
```
🔹 merge() — Production Tags के लिए बहुत important

Multiple maps को combine करता है।
```
variable "common_tags" {
  default = {
    owner = "devops"
    team  = "cloud"
  }
}

variable "environment_tags" {
  default = {
    environment = "dev"
  }
}

output "final_tags" {
  value = merge(
    var.common_tags,
    var.environment_tags
  )
}
```
### 🚀 Output
```
{
  owner       = "devops"
  team        = "cloud"
  environment = "dev"
}
```
## 5️⃣ Type Conversion Functions

Terraform में कभी-कभी एक data type को दूसरे data type में convert करना पड़ता है।

🔹 tostring()
```
output "converted_string" {
  value = tostring(100)
}
```
Output:
```
"100"
```
🔹 tonumber()
```
output "converted_number" {
  value = tonumber("100")
}
```
Output:
```
100
```
🔹 tolist()
```
output "converted_list" {
  value = tolist(["dev", "qa", "prod"])
}
```
🔹 tomap()
```
output "converted_map" {
  value = tomap({
    environment = "dev"
  })
}
```
🔹 toset()

Duplicate values हटाने के लिए useful है।
```
output "converted_set" {
  value = toset(["dev", "dev", "qa", "prod"])
}
```
Conceptual result:
```
dev
qa
prod
```
⚠️ Set में ordering guaranteed नहीं होती।

## 6️⃣ Conditional Expression

Terraform में condition के आधार पर value select करने के लिए conditional expression बहुत useful है।

Syntax:
```
condition ? true_value : false_value
```
Example:
```
variable "environment" {
  default = "prod"
}

output "instance_size" {
  value = var.environment == "prod"
    ? "Standard_D4s_v5"
    : "Standard_B2s"
}
```
## 🚀 Output

अगर environment prod है:
```
Standard_D4s_v5
```
अगर environment dev है:

Standard_B2s
## 7️⃣ File Functions

Terraform external files से data पढ़ सकता है।

🔹 file()
```hcl
file("${path.module}/config.txt")
fileexists("${path.module}/config.txt")
templatefile("${path.module}/template.tpl", { env = var.environment })
```

```
output "config_file" {
  value = file("${path.module}/config.txt")
}
```
यह config.txt की content पढ़ेगा।

🔹 fileexists()

Check करता है कि file मौजूद है या नहीं।
```
output "file_available" {
  value = fileexists("${path.module}/config.txt")
}
```
Output:
```
true
```
## 8️⃣ try()

अगर expression fail हो सकता है तो fallback value देने के लिए try() useful है।
```
variable "config" {
  default = {
    environment = "dev"
  }
}

output "owner" {
  value = try(var.config.owner, "unknown")
}
```
अगर owner available नहीं है:

unknown
## 9️⃣ can()

Check करता है कि expression successfully evaluate हो सकता है या नहीं।
```
variable "environment" {
  default = "dev"
}

output "validation_check" {
  value = can(var.environment)
}
```
Output:
```
true
```
## 🔟 coalesce()

पहली non-empty value return करता है।
```
output "environment" {
  value = coalesce("", "", "dev", "prod")
}
```
Output:
```
dev
```
## 1️⃣1️⃣ jsonencode()

Terraform value को JSON string में convert करता है।
```
variable "config" {
  default = {
    environment = "dev"
    owner       = "devops"
  }
}

output "json_config" {
  value = jsonencode(var.config)
}
```
Output conceptually:
```
{"environment":"dev","owner":"devops"}
```
## 1️⃣2️⃣ jsondecode()

JSON string को Terraform data structure में convert करता है।
```
locals {
  config = jsondecode(
    "{\"environment\":\"dev\",\"owner\":\"devops\"}"
  )
}

output "environment" {
  value = local.config.environment
}
```
Output:
```
dev
```
### ☁️ Production-Style Azure Example

अब Functions को Azure Resource Group के साथ use करते हैं।
नीचे **real production pattern** दिया गया है।  
यह pattern enterprise projects में बहुत common है।

### File Structure
```
├── providers.tf
├── variables.tf
├── terraform.tfvars
├── locals.tf
├── main.tf
├── outputs.tf
└── versions.tf
```

### variables.tf
```
variable "environment" {
  type        = string
  description = "Deployment environment"

  validation {
    condition     = contains(["dev", "qa", "prod"], var.environment)
    error_message = "Environment must be dev, qa or prod."
  }
}

variable "project_name" {
  type        = string
  description = "Project name"
}
```
### terraform.tfvars
```
environment = "dev"
project_name = "payment"
```
### main.tf
```
locals {
  resource_group_name = lower(
    "${var.project_name}-${var.environment}-rg"
  )

  common_tags = {
    project     = var.project_name
    environment = var.environment
    managed_by  = "terraform"
  }
}

resource "azurerm_resource_group" "this" {

  name     = local.resource_group_name
  location = "West Europe"

  tags = local.common_tags
}
```
## 🚀 Expected Resource
Resource Group:
payment-dev-rg

Location:
West Europe

Tags:
project     = payment
environment = dev
managed_by  = terraform
### 🔥 Function + for_each Example

Functions को for_each के साथ combine करना production Terraform में बहुत common है।

### terraform.tfvars
```
resource_groups = {
  frontend = {
    name     = "payment-frontend-rg"
    location = "West Europe"
  }

  backend = {
    name     = "payment-backend-rg"
    location = "West Europe"
  }
}
```
### variables.tf
```
variable "resource_groups" {
  type = map(object({
    name     = string
    location = string
  }))
}
```
### main.tf
```
resource "azurerm_resource_group" "this" {

  for_each = var.resource_groups

  name     = lower(each.value.name)
  location = each.value.location
}
```
### 🚀 Expected Plan
Plan: 2 to add, 0 to change, 0 to destroy.

Resources:

payment-frontend-rg
payment-backend-rg

## 🧠 What is for_each?

for_each tells Terraform:

"Take this collection and create one resource/module instance for every item in it."

Instead of writing:
```
resource "azurerm_resource_group" "rg1" {
  name     = "rg-dev"
  location = "West Europe"
}

resource "azurerm_resource_group" "rg2" {
  name     = "rg-qa"
  location = "West Europe"
}
```

you can write one resource block and create multiple Resource Groups using for_each.

🔑 What can for_each use?

The two important collection types are:

### 1. map

Best when every item has a key + value.

variable "resource_groups" {
  type = map(object({
    name     = string
    location = string
  }))
}

Values:

resource_groups = {
  dev = {
    name     = "rg-dev"
    location = "West Europe"
  }

  qa = {
    name     = "rg-qa"
    location = "Central India"
  }
}

Resource:

resource "azurerm_resource_group" "rg" {

  for_each = var.resource_groups

  name     = each.value.name
  location = each.value.location
}

Terraform creates:

azurerm_resource_group.rg["dev"]
azurerm_resource_group.rg["qa"]
### 2. set

Use a set(string) when you only need a collection of unique values.

variable "resource_group_names" {
  type = set(string)
}

Values:

resource_group_names = [
  "rg-dev",
  "rg-qa",
  "rg-prod"
]

Resource:

resource "azurerm_resource_group" "rg" {

  for_each = var.resource_group_names

  name     = each.value
  location = "West Europe"
}

Here:

each.key
each.value

will represent the set element.

### 🧱 Most Important for_each Keywords

When using for_each, remember these two:

each.key
each.value

For a map:

for_each = var.resource_groups

Suppose:

resource_groups = {
  dev = {
    name     = "rg-dev"
    location = "West Europe"
  }
}

Then:

each.key

is:

dev

and:

each.value.name

is:

rg-dev

while:

each.value.location

is:

West Europe
### 🚀 Production-Style Azure Example

This is the pattern I recommend you learn properly because it matches the kind of code you're already building with your Azure modules.

### variables.tf
```
variable "RG" {

  description = "Azure Resource Groups configuration"

  type = map(object({
    name     = string
    location = string
  }))
}
```
### terraform.tfvars
```
RG = {

  "Resource-PG" = {
    name     = "Pradip-RG"
    location = "West Europe"
  }

  "Resource-QA" = {
    name     = "Pradip-QA-RG"
    location = "Central India"
  }

  "Resource-DEV" = {
    name     = "Pradip-DEV-RG"
    location = "East US"
  }
}
```
### main.tf

```
resource "azurerm_resource_group" "Resource-PG" {

  # Terraform creates one Resource Group
  # for every item in var.RG

  for_each = var.RG

  # each.value comes from terraform.tfvars

  name     = each.value.name
  location = each.value.location
}
```
Terraform will create:
```
Pradip-RG
Pradip-QA-RG
Pradip-DEV-RG
```
without writing three separate resource blocks.

### 📊 How Terraform Thinks
terraform.tfvars
       │
       ▼
      RG map
       │
       ├── Resource-PG
       ├── Resource-QA
       └── Resource-DEV
              │
              ▼
          for_each
              │
       ┌──────┼──────┐
       ▼      ▼      ▼
      RG1    RG2    RG3

That's the real power of for_each.

### 🔥 for_each with Modules

for_each isn't limited to resources.

You can also use it with modules.

Example:
```
module "resource_group" {

  for_each = var.RG

  source = "../../../Child module/Azurerm_Resource_group"

  RG = {
    (each.key) = each.value
  }
}
```
This becomes especially useful when your project starts becoming modular and environment-based.

### ⚖️ for_each vs count

This is important for interviews.

Feature	for_each	count
Input	Map / Set	Number
Access	each.key, each.value	count.index
Best for	Named resources	Similar indexed resources
Identity	Key-based	Index-based
Readability	High	Moderate
Complex configuration	Excellent	Less convenient
count
```
resource "azurerm_resource_group" "rg" {

  count = 3

  name     = "rg-${count.index}"
  location = "West Europe"
}
```
Terraform creates:
```
rg-0
rg-1
rg-2
for_each
resource "azurerm_resource_group" "rg" {

  for_each = toset([
    "dev",
    "qa",
    "prod"
  ])

  name     = "rg-${each.value}"
  location = "West Europe"
}
```
Creates:
```
rg-dev
rg-qa
rg-prod
```
For named infrastructure, for_each is generally easier to understand and maintain.

### ⚠️ Important Rule

Don't think:

for_each = "create many resources"

Think:

for_each = "create one resource instance for each unique key/value in a collection."

And the collection must be suitable for for_each, primarily a map or set of strings.

### 🚀 Real Output Example

For:
```
RG = {
  dev = {
    name     = "rg-dev"
    location = "West Europe"
  }

  qa = {
    name     = "rg-qa"
    location = "Central India"
  }
}
```
terraform plan will show two instances:
```
#azurerm_resource_group.rg["dev"] will be created
#azurerm_resource_group.rg["qa"] will be created

Plan: 2 to add, 0 to change, 0 to destroy.
```
## ✅ Good Practice

✔ Prefer for_each when resources have meaningful names/keys
✔ Use map(object({...})) for structured Azure configurations
✔ Use each.key and each.value correctly
✔ Keep variable structure predictable
✔ Use meaningful keys such as dev, qa, prod
✔ Use modules with for_each for reusable infrastructure
✔ Add variable type constraints
✔ Use validation where appropriate

## ❌ Bad Practice

❌ Duplicate resource blocks for identical patterns
❌ Random keys such as abc1, xyz2
❌ Using complicated expressions unnecessarily
❌ Mixing unrelated resources into one collection
❌ Hardcoding values that should come from variables
❌ Using count simply because it looks shorter when resources need stable names

## 😂 DevOps Comedy

Without for_each:

"Bhai 50 Resource Groups banane hain." 😭

Terraform:

"50 blocks likh."

With for_each:

"Bas collection de bhai… बाकी मैं संभाल लूंगा." 😎

## 🎯 Interview Closing Line

for_each is a Terraform meta-argument used to create multiple instances of a resource or module from a map or set, providing stable, key-based resource addressing and making infrastructure code reusable and scalable.

### 🧪 Terraform Console से Functions Practice

Terraform functions सीखने के लिए terraform console बहुत useful है।

Run:

terraform console

फिर:

upper("terraform")

Output:

"TERRAFORM"

Try:

length(["dev", "qa", "prod"])

Output:

3

Try:

max(10, 50, 20)

Output:

50

Try:

join("-", ["terraform", "azure", "dev"])

Output:

"terraform-azure-dev"

Exit:

exit
## 🔗 Functions + Variables + Locals

Production Terraform में Functions अकेले नहीं बल्कि Variables और Locals के साथ बहुत ज्यादा use होते हैं।

Typical flow:

terraform.tfvars
       ↓
variables.tf
       ↓
var.variable
       ↓
locals
       ↓
Terraform Functions
       ↓
resource
       ↓
Azure

Example:
```
locals {
  rg_name = lower(
    "${var.project_name}-${var.environment}-rg"
  )
}
```
फिर:
```
resource "azurerm_resource_group" "this" {

  name     = local.rg_name
  location = var.location
}
```
### 🧠 Important Difference
Variable

Input लेने के लिए:

var.environment
Local

Calculated/reusable value रखने के लिए:

local.resource_group_name
Function

Value को process करने के लिए:

lower(...)
Resource

Actual Azure resource create करने के लिए:

resource "azurerm_resource_group" "this" {
}

Simple formula:

Variable
   ↓
Function
   ↓
Local
   ↓
Resource
### ✅ Good Practice

✔ Function का उपयोग meaningful transformation के लिए करो

✔ Complex expressions को locals में रखो

✔ Resource names consistent रखो

✔ Environment naming convention follow करो

✔ terraform console से functions practice करो

✔ Functions को Variables और Locals के साथ combine करना सीखो

✔ Production code readable रखो

✔ Type-safe variables use करो

### ❌ Bad Practice

❌ बिना जरूरत बहुत complex nested functions लिखना

❌ एक ही expression में बहुत सारे functions डालकर code unreadable बनाना

❌ Resource names में inconsistent naming

❌ Hardcoded environment-specific values

❌ Functions का use सिर्फ code को छोटा दिखाने के लिए करना

### 😂 DevOps Comedy

Developer:

"Bhai resource name dynamic chahiye."

Terraform:

"Function use kar le bhai!" 😎

Developer:

"Uppercase bhi chahiye."

Terraform:

upper(...)

Developer:

"Duplicate bhi remove karna hai."

Terraform:

distinct(...)

Developer:

"List bhi join karni hai."

Terraform:

join(...)

Terraform:

"Aur kuch? Coffee bana du?" 😂☕

### 🚀 Real Learning Challenge

नीचे दिए गए input से dynamic Resource Group name बनाओ:

project_name = "Payment"
environment  = "DEV"

Expected:

payment-dev-rg

Hint:

lower(...)

और:

"${...}-${...}-rg"
🏆 Function Learning Checklist
[ ] String Functions
[ ] Numeric Functions
[ ] Collection Functions
[ ] Map Functions
[ ] Type Conversion
[ ] Conditional Expression
[ ] File Functions
[ ] try()
[ ] can()
[ ] coalesce()
[ ] jsonencode()
[ ] jsondecode()
[ ] terraform console
[ ] Functions + Variables
[ ] Functions + Locals
[ ] Functions + for_each
[ ] Functions + Azure Resources
🎯 Interview Questions
Q1. Terraform Function क्या है?

Terraform Function एक built-in operation है जो input value को transform, calculate या process करता है।

Q2. upper() और lower() का क्या use है?
upper("dev")

Output:

DEV
lower("DEV")

Output:

dev
Q3. lookup() कब use करेंगे?

जब Map से किसी specific key की value निकालनी हो।

Q4. merge() क्या करता है?

Multiple maps को एक map में combine करता है।

Q5. distinct() क्या करता है?

Collection से duplicate values remove करता है।

Q6. try() और can() में क्या difference है?
try()
 ↓
Expression fail होने पर fallback value देता है

can()
 ↓
बताता है expression successfully evaluate हो सकता है या नहीं
Q7. Terraform Functions कहाँ test कर सकते हैं?
terraform console
🏭 Production Mindset

Production Terraform में Functions का उद्देश्य केवल code छोटा करना नहीं है।

मुख्य उद्देश्य:

Consistency
     +
Reusability
     +
Dynamic Configuration
     +
Environment Flexibility
     +
Readable IaC
     =
Production-Ready Terraform
### 🎯 Interview Closing Line

"Terraform Functions allow us to dynamically transform and calculate values, making Infrastructure as Code more reusable, consistent, and environment-aware."

### 🚀 Next Topic

Functions समझने के बाद अगला important topic:

Terraform Meta-Arguments
        ↓
count
        ↓
for_each
        ↓
depends_on
        ↓
lifecycle
        ↓
dynamic blocks

यहीं से Terraform का code simple configuration से production-level IaC बनना शुरू होता है। 😎


# 🧪 Example 1: count (Multiple Resources)

यदि हमें 3 Resource Groups बनाने हों, तो हम `count` का उपयोग कर सकते हैं।

If we want to create 3 Resource Groups, we can use the `count` argument.



### 📄 main.tf

```hcl
resource "azurerm_resource_group" "rg" {

  # count का मतलब कितनी बार resource बनेगा
  count = 3

  # प्रत्येक Resource Group का नाम अलग होगा
  name = "rg-demo-${count.index}"

  location = "Central India"
}
```

### समझें

- count = 3 → 3 बार resource बनेगा
- count.index → 0, 1, 2

Azure में बनेगा:
- rg-demo-0
- rg-demo-1
- rg-demo-2

---

# 🧪 Example 2: Variables with Default Value

यदि हम variable को default value देना चाहें तो ऐसा कर सकते हैं।

We can assign default values to variables.

---

### 📄 variables.tf

```hcl
variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"
}
```

### main.tf

```hcl
# Variable interpolation का उपयोग
name = "rg-${var.environment}"
```

अगर tfvars में कुछ नहीं दिया तो default "dev" उपयोग होगा।

---

# 🧪 Example 3: Conditional Expression

यदि environment prod है तो अलग नाम, अन्यथा अलग नाम।

We can apply conditional logic.

---

```hcl
name = var.environment == "prod" ? "rg-production" : "rg-development"
```

यदि environment = prod → rg-production  
अन्यथा → rg-development

---

# 🧪 Example 4: Built-in Function (upper)

हम नाम को uppercase में बदल सकते हैं।

We can transform strings using built-in functions.

---

```hcl
name = upper("rg-devops-demo")
```

Output:
```
RG-DEVOPS-DEMO
```
---

# 🧪 Example 5: lower() (Azure Important)

Azure में Storage Account का नाम lowercase होना अनिवार्य है।

Azure Storage Account names must be lowercase.

```hcl
resource "azurerm_storage_account" "sa" {
  name = lower("MyStorageDemo123")
}
```

Output:
```
mystoragedemo123
```
---

# 📌 What You Learned

✔ count से multiple resources  
✔ Variables में default value  
✔ Conditional logic  
✔ Built-in functions (upper, lower)  
✔ Dynamic naming and Expressions  

---

# ☁️ Terraform Azure Interview Q&A (Easy Hinglish)

---

### 1. What is count in Terraform?

`count` multiple identical resources बनाने के लिए उपयोग होता है।

It is used to create multiple identical resources.

⚠ Limitation: Index based tracking होने के कारण बीच का resource हटाने पर recreation हो सकता है।

---

### 2. How do Conditional Expressions work?

Syntax: `condition ? true : false`

Azure Example:

```hcl
count = var.env == "prod" ? 1 : 0
```

अगर env = prod → 1 resource  
अन्यथा → 0 resource  

---

### 3. When is Default Variable value used?

जब variable की value बाहर से provide नहीं की जाती, तब default value उपयोग होती है।

If no value is passed externally, Terraform uses the default value.

---

### 4. Why are Terraform Functions used?

Terraform functions data को modify या calculate करने के लिए उपयोग होती हैं।

Examples:

- `lower()` → Storage account lowercase बनाना
- `upper()` → Display formatting
- `join()` → Name combine करना
- `lookup()` → Map से value निकालना
- `cidrsubnet()` → Subnet IP calculation

---

# Key Azure Resource Reference Table

| Feature | Azure Resource Example |
|----------|------------------------|
| Logic | azurerm_resource_group |
| Iteration | azurerm_virtual_network subnets |
| Naming | azurerm_storage_account |

---

# 😎 DevOps Reality

Production में infrastructure static नहीं होता।

Real DevOps engineer वही है जो:

- Reusable code लिखे
- Dynamic naming करे
- Environment based automation करे

Click-click engineer नहीं 😄

---

### 📌 Author  
**Pradip Gavhankar**  
*DevOps | Cloud | DevSecOps | FinOps | AIOps| MLOps Learning Journey*------
