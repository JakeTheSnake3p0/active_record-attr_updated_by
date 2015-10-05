require 'spec_helper'
describe ActiveRecord::AttrUpdatedBy do
  let(:loner) { Ostracized.new }
  let(:bad_associations) { BadAssociations.new }
  let(:ok_bad_attribute) { BadAttribute.new }
  let(:bad_attribute) { BadAttribute.new timestamped_at: 'Barf' }
  let(:no_attribute) { WithoutTimestamp.new }
  let(:no_associations) { WithoutAssociations.new }
  let(:associated) { WithAssociations.new }

  it 'does not affect classes which do not utilize it' do
    # Check to see if the watcher is watching this class
    expect(ActiveRecord::AttrUpdatedBy::AttrWatcher.instance.watched(loner)).to be_nil
  end

  context "updates attribute's timestamp" do
    it 'unless the attribute is of an invalid data type' do
      # Nil is acceptable, but anything other than a timestamp isn't
      expect { ok_bad_attribute }.not_to raise_error
      expect { bad_attribute }.to raise_error(ArgumentError)
    end

    context 'even without associations' do
      it 'if the instance has been updated' do
        expect(no_associations.timestamped_at).to be_nil
        # Trigger a change in the model
        no_associations.marked_for_change = true
        Timecop.freeze(Time.now + 2.seconds) do
          no_associations.save!
          no_associations.reload
          expect(no_associations.timestamped_at.to_i).to eq(Time.now.to_i)
        end
      end

      it "unless the instance hasn't been updated" do
        expect(no_associations.timestamped_at).to be_nil
        no_associations.save!
        no_associations.reload
        expect(no_associations.timestamped_at).to be_nil
      end
    end

    context 'with associated attributes' do
      it 'when they have changed' do
        # Change just method1
        expect(associated.timestamped_at).to be_nil
        associated.method1 = 1
        associated.save!
        associated.reload
        expect(associated.timestamped_at.to_i).to eq(Time.now.to_i)
        # Make sure the timestamps aren't the same
        Timecop.freeze(Time.now + 2.seconds) do
          # Change just method2
          associated.method2 = 1
          associated.save!
          associated.reload
          expect(associated.timestamped_at.to_i).to eq(Time.now.to_i)
        end
      end

      it "unless those attributes haven't been updated" do
        expect(associated.timestamped_at).to be_nil
        associated.save!
        associated.reload
        expect(associated.timestamped_at).to be_nil
      end

      it 'but not on unrelated attributes' do
        expect(associated.timestamped_at).to be_nil
        # Trigger a change in an ignored attribute
        associated.ignored = 'Blah blah'
        associated.save!
        associated.reload
        expect(associated.timestamped_at).to be_nil
      end
    end
  end

  context 'complains about non-existent' do
    it 'attributes' do
      expect { no_attribute }.to raise_error(ActiveRecord::UnknownAttributeError)
    end

    it 'associations' do
      expect { bad_associations }.to raise_error(ActiveRecord::UnknownAttributeError)
    end
  end
end
