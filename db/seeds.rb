# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

applications = Application.create!([{ name: 'Nagano' }, { name: 'Mobia' }])

installations = Installation.create!([{ name: 'icm', location: 'location', env: 'production', application: applications.first },
                                      { name: 'chuq', location: 'location', env: 'production', application: applications.first },
                                      { name: 'icm', location: 'location', env: 'production', application: applications.last }])

states = State.create!([{ ref: 'dfg85dfg2fd6f9df5g665fffffds', branch: 'master', diff: 'diff text', installation: installations[0] },
                        { ref: 'srthrsth85231gsrhsrhg546668t', branch: 'master', installation: installations[0] },
                        { ref: '12sfgh5sf6gh48fsgh566f5sg4hg', branch: 'master', installation: installations[1] },
                        { ref: 'sf6h54sr6t54hs5r4hss5rth456h', branch: 'master', installation: installations[2] }])
