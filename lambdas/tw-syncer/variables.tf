variable "region" {
  type = string
  description = "Service region"
  default = "ap-southeast-2"
}

variable "timeout" {
  type = number
  description = "Set timeout for lambda function"
  default = 300
}

variable "memory_size" {
  type = number
  description = "Set memory size for lambda invocation"
  default = 256
}
variable "environment_variables" {
  type = "map"
  description = "Environment variables used by lambda function"
  default = {}
}

variable "schedule_expression" {
  type = string
  description = "Cloud watch event schedule expression"
  default = "rate(6 hours)"
}

variable "trends_available_schedule_expression" {
  type = string
  description = "Cloud watch event schedule expression for trends available"
  default = "rate(7 days)"
}

variable "lambda_function_s3_bucket" {
  type = string
  description = "The S3 bucket location containing the function's deployment package"
}

variable "lambda_function_s3_key" {
  type = string
  description = "The S3 key of an object containing the function's deployment package."
}

variable "timelines" {
  type = list(object({
    screen_name = string
    schedule_expression = string
  }))

  default = [
    {
      screen_name = "BarackObama"
      schedule_expression = "cron(0 0 * * ? *)"
    },
    {
      screen_name = "realDonaldTrump"
      schedule_expression = "cron(5 0 * * ? *)"
    },
    {
      screen_name = "Schwarzenegger"
      schedule_expression = "cron(10 0 * * ? *)"
    },
    {
      screen_name = "SenSanders"
      schedule_expression = "cron(15 0 * * ? *)"
    },
    {
      screen_name = "BillClinton"
      schedule_expression = "cron(20 0 * * ? *)"
    },
    {
      screen_name = "SenWarren"
      schedule_expression = "cron(25 0 * * ? *)"
    },
    {
      screen_name = "SecretaryCarson"
      schedule_expression = "cron(30 0 * * ? *)"
    },
    {
      screen_name = "SpeakerPelosi"
      schedule_expression = "cron(35 0 * * ? *)"
    },
    {
      screen_name = "GovMikeHuckabee"
      schedule_expression = "cron(40 0 * * ? *)"
    },
    {
      screen_name = "tedcruz"
      schedule_expression = "cron(45 0 * * ? *)"
    },
    {
      screen_name = "JohnKerry"
      schedule_expression = "cron(50 0 * * ? *)"
    },
    {
      screen_name = "KamalaHarris"
      schedule_expression = "cron(55 0 * * ? *)"
    },
    {
      screen_name = "GabbyGiffords"
      schedule_expression = "cron(0 1 * * ? *)"
    },
    {
      screen_name = "Mike_Pence"
      schedule_expression = "cron(5 1 * * ? *)"
    },
    {
      screen_name = "RepAdamSchiff"
      schedule_expression = "cron(10 1 * * ? *)"
    },
    {
      screen_name = "alfranken"
      schedule_expression = "cron(15 1 * * ? *)"
    },
    {
      screen_name = "SenSchumer"
      schedule_expression = "cron(20 1 * * ? *)"
    },
    {
      screen_name = "newtgingrich"
      schedule_expression = "cron(25 1 * * ? *)"
    },
    {
      screen_name = "AndrewYang"
      schedule_expression = "cron(30 1 * * ? *)"
    },
    {
      screen_name = "PeteButtigieg"
      schedule_expression = "cron(35 1 * * ? *)"
    },
    {
      screen_name = "CoryBooker"
      schedule_expression = "cron(40 1 * * ? *)"
    },
    {
      screen_name = "NikkiHaley"
      schedule_expression = "cron(45 1 * * ? *)"
    },
    {
      screen_name = "SenatorDole"
      schedule_expression = "cron(50 1 * * ? *)"
    },
    {
      screen_name = "SarahPalinUSA"
      schedule_expression = "cron(55 1 * * ? *)"
    },
    {
      screen_name = "RonPaul"
      schedule_expression = "cron(0 2 * * ? *)"
    },
    {
      screen_name = "TulsiGabbard"
      schedule_expression = "cron(5 2 * * ? *)"
    },
    {
      screen_name = "TGowdySC"
      schedule_expression = "cron(10 2 * * ? *)"
    },
    {
      screen_name = "JulianCastro"
      schedule_expression = "cron(15 2 * * ? *)"
    },
    {
      screen_name = "SenFeinstein"
      schedule_expression = "cron(20 2 * * ? *)"
    },
    {
      screen_name = "LindseyGrahamSC"
      schedule_expression = "cron(25 2 * * ? *)"
    },
    {
      screen_name = "JerryBrownGov"
      schedule_expression = "cron(30 2 * * ? *)"
    },
    {
      screen_name = "SenGillibrand"
      schedule_expression = "cron(35 2 * * ? *)"
    },
    {
      screen_name = "senatemajldr"
      schedule_expression = "cron(40 2 * * ? *)"
    },
    {
      screen_name = "SenDuckworth"
      schedule_expression = "cron(45 2 * * ? *)"
    },
    {
      screen_name = "AllenWest"
      schedule_expression = "cron(50 2 * * ? *)"
    },
    {
      screen_name = "SteveScalise"
      schedule_expression = "cron(55 2 * * ? *)"
    },
    {
      screen_name = "RBReich"
      schedule_expression = "cron(0 3 * * ? *)"
    },
    {
      screen_name = "donnabrazile"
      schedule_expression = "cron(5 3 * * ? *)"
    },
    {
      screen_name = "timkaine"
      schedule_expression = "cron(10 3 * * ? *)"
    },
    {
      screen_name = "JoeBiden"
      schedule_expression = "cron(15 3 * * ? *)"
    },
    {
      screen_name = "ewarren"
      schedule_expression = "cron(20 3 * * ? *)"
    },
    {
      screen_name = "WhiteHouse"
      schedule_expression = "cron(25 3 * * ? *)"
    },
    {
      screen_name = "HillaryClinton"
      schedule_expression = "cron(30 3 * * ? *)"
    },
    {
      screen_name = "MrKRudd"
      schedule_expression = "cron(35 3 * * ? *)"
    },
    {
      screen_name = "TurnbullMalcolm"
      schedule_expression = "cron(40 3 * * ? *)"
    },
    {
      screen_name = "JuliaGillard"
      schedule_expression = "cron(45 3 * * ? *)"
    },
    {
      screen_name = "HonTonyAbbott"
      schedule_expression = "cron(50 3 * * ? *)"
    },
    {
      screen_name = "ScottMorrisonMP"
      schedule_expression = "cron(55 3 * * ? *)"
    },
    {
      screen_name = "billshortenmp"
      schedule_expression = "cron(0 4 * * ? *)"
    },
    {
      screen_name = "DarrynLyons"
      schedule_expression = "cron(5 4 * * ? *)"
    },
    {
      screen_name = "HonJulieBishop"
      schedule_expression = "cron(10 4 * * ? *)"
    },
    {
      screen_name = "SenatorWong"
      schedule_expression = "cron(15 4 * * ? *)"
    },
    {
      screen_name = "tanya_plibersek"
      schedule_expression = "cron(20 4 * * ? *)"
    }
  ]
}

variable "places" {
  type = list(object({
    id = number
    schedule_expression = string
  }))

  default = [
    {
      woeid = 1
      schedule_expression = "cron(1 0 * * ? *)"
    },
    {
      // ca : Ottawa
      woeid = 2972
      schedule_expression = "cron(2 0 * * ? *)"
    },
    {
      // ca: Quebec
      woeid = 3369
      schedule_expression = "cron(3 0 * * ? *)"
    },
    {
      // ca: Montreal
      woeid = 3444
      schedule_expression = "cron(4 0 * * ? *)"
    },
    {
      // ca: Toronto
      woeid = 3534
      schedule_expression = "cron(5 0 * * ? *)"
    },
    {
      // ca: Edmonton
      woeid = 4118
      schedule_expression = "cron(6 0 * * ? *)"
    },
    {
      // ca: Calgary
      woeid = 8676
      schedule_expression = "cron(7 0 * * ? *)"
    },
    {
      // ca: Vancouver
      woeid = 8775
      schedule_expression = "cron(8 0 * * ? *)"
    },
    {
      // ca: Birmingham
      woeid = 9807
      schedule_expression = "cron(9 0 * * ? *)"
    },
    {
      // gb: Liverpool
      woeid = 26062
      schedule_expression = "cron(10 0 * * ? *)"
    },
    {
      // gb: Manchester
      woeid = 26734
      schedule_expression = "cron(11 0 * * ? *)"
    },
    {
      // gb: Newcastle
      woeid = 28869
      schedule_expression = "cron(12 0 * * ? *)"
    },
    {
      // au: Adelaide
      woeid = 1098081
      schedule_expression = "cron(13 0 * * ? *)"
    },
    {
      // au: brisbane
      woeid = 1099805
      schedule_expression = "cron(14 0 * * ? *)"
    },
    {
      // au: Canberra
      woeid = 1100661
      schedule_expression = "cron(15 0 * * ? *)"
    },
    {
      // au: Darwin
      woeid = 1100968
      schedule_expression = "cron(16 0 * * ? *)"
    },
    {
      // au: Melbourne
      woeid = 1101597
      schedule_expression = "cron(17 0 * * ? *)"
    },
    {
      // au: Sydney
      woeid = 1103816
      schedule_expression = "cron(18 0 * * ? *)"
    }
  ]
}
