require "rails_helper"

describe Party do

  subject(:party) { create(:party) }

  it { is_expected.to have_db_column(:name) }
  it { is_expected.to have_db_column(:code) }

  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_presence_of(:code) }

  it { is_expected.to validate_uniqueness_of(:name) }
  it { is_expected.to validate_uniqueness_of(:code) }
end
