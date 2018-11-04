require 'active_storage/blob/analyzable'

module ::ActiveStorage::Blob::Analyzable
  alias_method :analyze_original, :analyze

  def analyze
    analyze_original
    records_callback
  end

  def records_callback
    self.attachments.each do |a|
      next unless defined? a.record.after_analyze
      a.record.after_analyze
    end
  end
end
