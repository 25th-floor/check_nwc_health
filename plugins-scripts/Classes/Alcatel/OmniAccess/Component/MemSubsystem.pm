package Classes::Alcatel::OmniAccess::Component::MemSubsystem;
our @ISA = qw(Monitoring::GLPlugin::SNMP::Item);
use strict;

sub init {
  my $self = shift;
  $self->get_snmp_tables('WLSX-SYSTEMEXT-MIB', [
      ['memories', 'wlsxSysExtMemoryTable', 'Classes::Alcatel::OmniAccess::Component::MemSubsystem::Memory'],
  ]);
}


package Classes::Alcatel::OmniAccess::Component::MemSubsystem::Memory;
our @ISA = qw(Monitoring::GLPlugin::SNMP::TableItem);
use strict;

sub finish {
  my $self = shift;
  $self->{usage} = 100 * $self->{sysExtMemoryUsed} / $self->{sysExtMemorySize};
}

sub check {
  my $self = shift;
  my $label = sprintf 'memory_%s_usage', $self->{flat_indices};
  $self->add_info(sprintf 'memory %s usage is %.2f%%',
      $self->{flat_indices}, $self->{usage});
  $self->set_thresholds(metric => $label, warning => 80, critical => 90);
  $self->add_message($self->check_thresholds(
      metric => $label, value => $self->{usage}));
  $self->add_perfdata(
      label => $label,
      value => $self->{usage},
      uom => '%',
  );
}

