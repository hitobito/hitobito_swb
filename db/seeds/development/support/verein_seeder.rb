class VereinSeeder
  attr_reader :parent_id, :name

  def initialize(parent_id:, name:)
    @parent_id = parent_id
    @name = name
  end

  def seed
    result = Group::Verein.seed_once(:name, parent_id:, name:)
    verein = result.first
    league_sample.each do |league|
      verein_prefix = name.gsub(/(BC|SC)\s/, "")
      team_name = [verein_prefix, league].join(" ")

      Team.seed_once(:name, group_id: verein.id, name: team_name, league: league, year: Time.zone.today.year)
    end
  end

  def league_sample
    InvoiceLists::TEAMS.cycle(rand(2..6)).to_a.sample(rand(1..10)).to_a
  end
end
