# Appropriate Bodies authenticate using a DfE Sign-In UUID unique to each ENV
#
def describe_appropriate_body(appropriate_body)
  print_seed_info(appropriate_body.name, indent: 2)
end

# DfE Sign-In environment domain prefix
def dfe_sign_in_env
  Rails.application.config.dfe_sign_in_issuer.include?('test') ? :test : :pp
end

appropriate_bodies = [
  # ----------------------------------------------------------------------------
  # 1. Single National ORG
  # 2. Permanently in operation
  {
    name: AppropriateBodies::Search::ISTIP,
    body_type: 'national',
    dqt_id: '6ae042bb-c7ae-e311-b8ed-005056822391',
    dfe_sign_in: {
      test: 'e38652da-b01f-4d14-af2a-d2f55e4fcf7b', # 👌🏼
      pp: '99424c22-b0c0-4307-bdf7-fabfe7cac252' # 👌🏼
    }
  },

  # 1. Single National ORG
  # 2. Permanently in operation
  {
    name: AppropriateBodies::Search::ESP,
    body_type: 'national',
    dfe_sign_in: {
      test: '722ebb41-42f6-4ba3-81b6-61af055246a5', # 👌🏼
      pp: 'b98cb613-192f-400e-9b50-fd7eea9882a1' # 👌🏼
    }
  },

  # AB: Five Counties Teaching School Hub Alliance
  # ----------------------------------------------------------------------------
  {
    name: 'Bristol Metropolitan Academy', # URN 135959
    body_type: 'teaching_school_hub', # Lead school
    dfe_sign_in: {
      test: '3f4e1f14-ac8c-48b0-a8b9-1c75b471bbcd', # 🖕🏼 NOT IN RIAB POLICY ONLY RECT
      pp: 'd0980f89-eda1-409d-bcd2-a88257ca7760' # 👌🏼
    }
  },
  {
    name: 'Mangotsfield Church of England Primary School', # URN 149948
    body_type: 'teaching_school_hub', # Lead school
    dfe_sign_in: {
      test: '473f201b-9f2d-4648-bb9e-750c292bb072', # 👌🏼
      pp: 'f53af8e7-b303-4e8e-9374-3a18c083f271' # 👌🏼
    }
  },

  # AB: Star Teaching School Hub
  # ----------------------------------------------------------------------------
  {
    name: "Eden Boys' School, Birmingham", # URN 141969
    body_type: 'teaching_school_hub', # Lead school
    dfe_sign_in: {
      test: '2720e261-f131-4f55-b9d4-b6618a8633d3', # 👌🏼
      pp: '49f7ccdb-b1a3-4154-851f-cd872f4b4bbe' # 👌🏼
    }
  },
  {
    name: "Eden Boys' School, Bolton", # URN 140959
    body_type: 'teaching_school_hub', # Lead school
    dfe_sign_in: {
      test: '191c7072-bd72-4d1c-989f-3747c6d14eec', # 👌🏼
      pp: 'b6cac4aa-dba8-4e81-8bbc-6dcad47785c6' # 👌🏼
    }
  },

  # ----------------------------------------------------------------------------
  # 1. Single Regional ORG?
  # 2. School and AB
  # 3. Has a period of operation
  {
    name: 'Angel Oak Academy', # URN 141666
    body_type: 'teaching_school_hub',
    dfe_sign_in: {
      test: '83173e6f-ba28-4654-a3df-8279d573ab09', # 👌🏼
      pp: '62fafd5e-2c25-4214-91ad-1de69262820a' # 👌🏼
    }
  },

  {
    name: 'Canvas Teaching School Hub',
    body_type: 'teaching_school_hub',
  },
  {
    name: 'South Yorkshire Studio Hub',
    body_type: 'teaching_school_hub',
  },
  {
    name: 'Ochre Education Partnership',
    body_type: 'teaching_school_hub',
  },
  {
    name: 'Umber Teaching School Hub',
    body_type: 'teaching_school_hub',
  },
  {
    name: 'Golden Leaf Teaching School Hub',
    body_type: 'teaching_school_hub',
  },
  {
    name: 'Frame University London',
    body_type: 'teaching_school_hub',
  },
  {
    name: 'Easelcroft Teaching School Hub',
    body_type: 'teaching_school_hub',
  },
  {
    name: 'Vista College',
    body_type: 'teaching_school_hub',
  }
]

# Seed ABs with enabled DSI UUIDs
#
# Check your local development ENVs
appropriate_bodies.each do |data|
  describe_appropriate_body FactoryBot.create(:appropriate_body,
                                              name: data[:name],
                                              body_type: data[:body_type],
                                              dfe_sign_in_organisation_id: data.dig(:dfe_sign_in, dfe_sign_in_env))
end
