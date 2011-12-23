module HomeHelper
  #data Атрибуты для УИК-а
  def filter_params(voting_table)
    {"data-attendance"=>voting_table.pct("poll"),
      "data-sr"=>voting_table.pct("sr"),
      "data-ldpr"=>voting_table.pct("ldpr"),
      "data-pr"=>voting_table.pct("pr"),
      "data-kprf"=>voting_table.pct("kprf"),
      "data-yabloko"=>voting_table.pct("yabloko"),
      "data-er"=>voting_table.pct("er"),
      "data-pd"=>voting_table.pct("pd")}
  end
end
