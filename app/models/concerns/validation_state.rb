module ValidationState
  extend ActiveSupport::Concern

  STATES = %w(record_invalid record_valid record_pending record_rejected record_approved)

  included do

    # Defines validation state machine with help from AASM gem.
    #
    # States:
    #
    # aasm_invalid - record has fields that have not passed validation
    # aasm_valid - record has passed validation
    # aasm_pending - record has been submitted for approval
    # aasm_rejected - record has been rejected by an approver
    # aasm_approved - record has been approved
    #
    # Note- state names and events prefixed with record_ to prevent conflict with existing
    # valid/invalid methods in ActiveRecord
    #
    include AASM

    aasm do
      state :record_invalid, initial: true
      state :record_valid
      state :record_pending
      state :record_rejected
      state :record_approved

      event :invalidate_record do
        transitions from: [:record_invalid, :record_valid, :record_pending, :record_rejected, :record_approved], to: :record_invalid
      end

      event :validate_record do
        transitions from: [:record_invalid, :record_rejected], to: :record_valid
      end

      event :submit_record do
        transitions from: :record_valid, to: :record_pending
      end

      event :withdraw_record do
        transitions from: :record_pending, to: :record_valid
      end

      event :reject_record do
        transitions from: [:record_pending, :record_approved], to: :record_rejected
      end

      event :approve_record do
        transitions from: :record_pending, to: :record_approved
      end
    end

    # Defines a conditional state for running validations.
    attr_writer :validate
    def validate?
      !!@validate # rubocop:disable DoubleNegation
    end

    # Requires notes to be submitted when transitioning to certain states
    validates :aasm_state_notes, presence: true, if: :record_rejected?

    # Save hook to change state as validation state changes
    before_save do
      self.validate = true
      if self.valid?
        validate_record if self.may_validate_record?
        self.aasm_state_errors = nil
      else
        invalidate_record
        self.aasm_state_errors = errors.to_json
      end
      self.validate = false
      true
    end

  end
end
