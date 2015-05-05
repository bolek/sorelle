require "rails_helper"

describe Politician do
  subject { create(:politician) }

  it { is_expected.to have_db_column(:fec_number) }
  it { is_expected.to have_db_column(:first_name) }
  it { is_expected.to have_db_column(:last_name) }

  it { is_expected.to have_db_index(:fec_number).unique(true) }

  it { is_expected.to validate_presence_of(:fec_number) }
  it { is_expected.to validate_presence_of(:first_name) }
  it { is_expected.to validate_presence_of(:last_name) }

  it { is_expected.to validate_uniqueness_of(:fec_number) }
end
