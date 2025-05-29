module Logic.WorkParams where

import Prelude

import Logic.Types (BusinessType, JobType)


jobClerk :: JobType
jobClerk = 
  { name : "Clerk"
  , hours : 160
  , money : 500.0
  }

jobSalesman :: JobType
jobSalesman = 
  { name : "Salesman"
  , hours : 120
  , money : 350.0
  }

jobPizzaDelivery :: JobType
jobPizzaDelivery =
  { name : "Pizza Delivery"
  , hours : 80
  , money : 250.0
  }

businessA :: BusinessType
businessA =
  { name : "businessA"
  , hours : 100
  , money : 300.0
  }

businessB :: BusinessType
businessB =
  { name : "businessB"
  , hours : 60
  , money : 200.0
  }