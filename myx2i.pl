use strict;
use vars qw($VERSION %IRSSI);

use Irssi qw(command_bind signal_add);
use IO::File;
$VERSION = '0.20';
%IRSSI = (
	authors		=> 'Jonn Mostovoy',
	contact		=> 'jm@memorici.de',
	name		=> 'myx2i',
	description	=> 'XMPP to IRC mirror',
	license		=> 'MIT',
	xmpp_chan   => 'spaceships@is.memorici.de',
	irc_chan    => '#xmpp',
	xmpp_say    => 'msg -xmpp:myx2i@memorici.de spaceships@is.memorici.de ',
	irc_say     => 'msg -192 #xmpp '
);

sub public_message {
	my ($server, $msg, $nick, $address, $target) = @_;
	if ($target eq $IRSSI{'irc_chan'}) {
		$_ = $msg;
		if (/^R2.+/) {
			$server->command($IRSSI{'xmpp_say'}.'R2: '.$nick.'> '.$msg);
		} else {
			$server->command($IRSSI{'xmpp_say'}.$nick.'> '.$msg);
		}
	} else {
		$server->command($IRSSI{'irc_say'}.$nick.'> '.$msg);
	}
}

signal_add("message public", "public_message");
