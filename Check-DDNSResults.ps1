function Check-DDNSsites
{
	param($engine,$safesearch = 'on',$provider = $all,$type = 'link',$userlist = "",$searchterm = "",$saveto = ($Env:USERPROFILE + '\Desktop\'),$allresults = 'no')
	$pathvalid = Test-Path -Path $saveto -IsValid
	$pathexist = Test-Path -Path $saveto -PathType Container
	
	if($pathvalid -eq $true -and $pathexist -eq $true)
	{
		$saveto = $saveto + 'DDNS-results.html'
		'<table>' + "`r`n" + '<tr>' + "`r`n" + '<th>Domain Name&nbsp&nbsp</th>' + "`r`n" + '<th>&nbsp&nbspResults [' + $engine + ']  </th>' + "`r`n" + '</tr>'|Out-File $saveto 
	}
	else
	{
		Write-Host " Save path of '$saveto' is invalid or folder does not exist " -ForegroundColor Yellow -BackgroundColor DarkRed
		$fail = 1
		break
	}
	if($userlist -ne "")
	{
		$usertest = Test-Path $userlist -PathType Leaf
		if($usertest -eq $true)
		{
			[array]$DynDNSDomains = Get-Content $userlist
		}
		else
		{
			Write-Host " User list '$userlist' cannot be found " -ForegroundColor Yellow -BackgroundColor DarkRed
			$fail = 1
			break			
		}
	}
	else
	{
		$DynDNSDomains = @()
		#region synology.com domains
		$synology =
		'synology.me',
		'DiskStation.me',
		'i234.me',
		'myDS.me',
		'DSCloud.biz',
		'DSCloud.me',
		'DSCloud.mobi',
		'DSmyNAS.com',
		'DSmyNAS.org',
		'DSmyNAS.net',
		'FamilyDS.com',
		'FamilyDS.org',
		'FamilyDS.net'
		#endregion
		#region dyn.com domains
		$dyn = 
		'at-band-camp.net',
		'barrel-of-knowledge.info',
		'barrell-of-knowledge.info',
		'better-than.tv',
		'blogdns.com',
		'blogdns.net',
		'blogdns.org',
		'blogsite.org',
		'boldlygoingnowhere.org',
		'broke-it.net',
		'buyshouses.net',
		'cechire.com',
		'dnsalias.com',
		'dnsalias.net',
		'dnsalias.org',
		'dnsdojo.com',
		'dnsdojo.net',
		'dnsdojo.org',
		'does-it.net',
		'doesntexist.com',
		'doesntexist.org',
		'dontexist.com',
		'dontexist.net',
		'dontexist.org',
		'doomdns.com',
		'doomdns.org',
		'dvrdns.org',
		'dyn-o-saur.com',
		'dynalias.com',
		'dynalias.net',
		'dynalias.org',
		'dynathome.net',
		'dyndns.ws',
		'endofinternet.net',
		'endofinternet.org',
		'endoftheinternet.org',
		'est-a-la-maison.com',
		'est-a-la-masion.com',
		'est-le-patron.com',
		'est-mon-blogueur.com',
		'for-better.biz',
		'for-more.biz',
		'for-our.info',
		'for-some.biz',
		'for-the.biz',
		'forgot.her.name',
		'forgot.his.name',
		'from-ak.com',
		'from-al.com',
		'from-ar.com',
		'from-az.net',
		'from-ca.com',
		'from-co.net',
		'from-ct.com',
		'from-dc.com',
		'from-de.com',
		'from-fl.com',
		'from-ga.com',
		'from-hi.com',
		'from-ia.com',
		'from-id.com',
		'from-il.com',
		'from-in.com',
		'from-ks.com',
		'from-ky.com',
		'from-la.net',
		'from-ma.com',
		'from-md.com',
		'from-me.org',
		'from-mi.com',
		'from-mn.com',
		'from-mo.com',
		'from-ms.com',
		'from-mt.com',
		'from-nc.com',
		'from-nd.com',
		'from-ne.com',
		'from-nh.com',
		'from-nj.com',
		'from-nm.com',
		'from-nv.com',
		'from-ny.net',
		'from-oh.com',
		'from-ok.com',
		'from-or.com',
		'from-pa.com',
		'from-pr.com',
		'from-ri.com',
		'from-sc.com',
		'from-sd.com',
		'from-tn.com',
		'from-tx.com',
		'from-ut.com',
		'from-va.com',
		'from-vt.com',
		'from-wa.com',
		'from-wi.com',
		'from-wv.com',
		'from-wy.com',
		'ftpaccess.cc',
		'fuettertdasnetz.de',
		'game-host.org',
		'game-server.cc',
		'getmyip.com',
		'gets-it.net',
		'go.dyndns.org',
		'gotdns.com',
		'gotdns.org',
		'groks-the.info',
		'groks-this.info',
		'ham-radio-op.net',
		'here-for-more.info',
		'hobby-site.com',
		'hobby-site.org',
		'home.dyndns.org',
		'homedns.org',
		'homeftp.net',
		'homeftp.org',
		'homeip.net',
		'homelinux.com',
		'homelinux.net',
		'homelinux.org',
		'homeunix.com',
		'homeunix.net',
		'homeunix.org',
		'iamallama.com',
		'in-the-band.net',
		'is-a-anarchist.com',
		'is-a-blogger.com',
		'is-a-bookkeeper.com',
		'is-a-bruinsfan.org',
		'is-a-bulls-fan.com',
		'is-a-candidate.org',
		'is-a-caterer.com',
		'is-a-celticsfan.org',
		'is-a-chef.com',
		'is-a-chef.net',
		'is-a-chef.org',
		'is-a-conservative.com',
		'is-a-cpa.com',
		'is-a-cubicle-slave.com',
		'is-a-democrat.com',
		'is-a-designer.com',
		'is-a-doctor.com',
		'is-a-financialadvisor.com',
		'is-a-geek.com',
		'is-a-geek.net',
		'is-a-geek.org',
		'is-a-green.com',
		'is-a-guru.com',
		'is-a-hard-worker.com',
		'is-a-hunter.com',
		'is-a-knight.org',
		'is-a-landscaper.com',
		'is-a-lawyer.com',
		'is-a-liberal.com',
		'is-a-libertarian.com',
		'is-a-linux-user.org',
		'is-a-llama.com',
		'is-a-musician.com',
		'is-a-nascarfan.com',
		'is-a-nurse.com',
		'is-a-painter.com',
		'is-a-patsfan.org',
		'is-a-personaltrainer.com',
		'is-a-photographer.com',
		'is-a-player.com',
		'is-a-republican.com',
		'is-a-rockstar.com',
		'is-a-socialist.com',
		'is-a-soxfan.org',
		'is-a-student.com',
		'is-a-teacher.com',
		'is-a-techie.com',
		'is-a-therapist.com',
		'is-an-accountant.com',
		'is-an-actor.com',
		'is-an-actress.com',
		'is-an-anarchist.com',
		'is-an-artist.com',
		'is-an-engineer.com',
		'is-an-entertainer.com',
		'is-by.us',
		'is-certified.com',
		'is-found.org',
		'is-gone.com',
		'is-into-anime.com',
		'is-into-cars.com',
		'is-into-cartoons.com',
		'is-into-games.com',
		'is-leet.com',
		'is-lost.org',
		'is-not-certified.com',
		'is-saved.org',
		'is-slick.com',
		'is-uberleet.com',
		'is-very-bad.org',
		'is-very-evil.org',
		'is-very-good.org',
		'is-very-nice.org',
		'is-very-sweet.org',
		'is-with-theband.com',
		'isa-geek.com',
		'isa-geek.net',
		'isa-geek.org',
		'isa-hockeynut.com',
		'issmarterthanyou.com',
		'isteingeek.de',
		'istmein.de',
		'kicks-ass.net',
		'kicks-ass.org',
		'knowsitall.info',
		'land-4-sale.us',
		'lebtimnetz.de',
		'leitungsen.de',
		'likes-pie.com',
		'likescandy.com',
		'merseine.nu',
		'mine.nu',
		'misconfused.org',
		'mypets.ws',
		'myphotos.cc',
		'neat-url.com',
		'office-on-the.net',
		'on-the-web.tv',
		'podzone.net',
		'podzone.org',
		'readmyblog.org',
		'saves-the-whales.com',
		'scrapper-site.net',
		'scrapping.cc',
		'selfip.biz',
		'selfip.com',
		'selfip.info',
		'selfip.net',
		'selfip.org',
		'sells-for-less.com',
		'sells-for-u.com',
		'sells-it.net',
		'sellsyourhome.org',
		'servebbs.com',
		'servebbs.net',
		'servebbs.org',
		'serveftp.net',
		'serveftp.org',
		'servegame.org',
		'shacknet.nu',
		'simple-url.com',
		'space-to-rent.com',
		'stuff-4-sale.org',
		'stuff-4-sale.us',
		'teaches-yoga.com',
		'thruhere.net',
		'traeumtgerade.de',
		'webhop.biz',
		'webhop.info',
		'webhop.net',
		'webhop.org',
		'worse-than.tv',
		'writesthisblog.com'
		#endregion
		#region no-ip.com domains
		$noip = 
		'blogsyte.com',
		'brasilia.me',
		'cable-modem.org',
		'ciscofreak.com',
		'collegefan.org',
		'couchpotatofries.org',
		'damnserver.com',
		'ddns.me',
		'ddns.net',
		'ditchyourip.com',
		'dnsfor.me',
		'dnsiskinky.com',
		'dvrcam.info',
		'dynns.com',
		'eating-organic.net',
		'fantasyleague.cc',
		'geekgalaxy.com',
		'golffan.us',
		'health-carereform.com',
		'homesecuritymac.com',
		'bounceme.net',
		'hopto.org',
		'myftp.biz',
		'myftp.org',
		'myvnc.com',
		'no-ip.biz',
		'no-ip.info',
		'homesecuritypc.com',
		'hopto.me',
		'ilovecollege.info',
		'loginto.me',
		'mlbfan.org',
		'mmafan.biz',
		'myactivedirectory.com',
		'mydissent.net',
		'myeffect.net',
		'mymediapc.net',
		'mypsx.net',
		'mysecuritycamera.com',
		'mysecuritycamera.net',
		'mysecuritycamera.org',
		'net-freaks.com',
		'nflfan.org',
		'nhlfan.net',
		'no-ip.ca',
		'no-ip.co.uk',
		'redirectme.net',
		'servebeer.com',
		'serveblog.net',
		'servecounterstrike.com',
		'serveftp.com',
		'servegame.com',
		'servehalflife.com',
		'no-ip.net',
		'noip.me',
		'noip.us',
		'pgafan.net',
		'point2this.com',
		'pointto.us',
		'privatizehealthinsurance.net',
		'quicksytes.com',
		'read-books.org',
		'securityexploits.com',
		'securitytactics.com',
		'serveexchange.com',
		'servehumour.com',
		'servep2p.com',
		'servesarcasm.com',
		'stufftoread.com',
		'ufcfan.org',
		'unusualperson.com',
		'webhop.me',
		'workisboring.com',
		'servehttp.com',
		'servemp3.com',
		'servepics.com',
		'servequake.com',
		'sytes.net',
		'zapto.org'
		#endregion
		#region ...and the rest
		$dyns = 
		'dyns.cx',
		'dyns.net',
		'ma.cx',
		'metadns.cx'
		$dnsexit = 
		'publicvm.com',
		'linkpc.net'
		#endregion
		
		$pl = 'Synology','Dyn','NoIP','DyNS','DNSexit'
		if($provider -eq 'all')
		{
			[array]$list = $synology,$dyn,$noip,$dyns,$dnsexit
		}
		elseif($pl -notcontains $provider)
		{
			Write-Host "Invalid DDNS provider name: $provider" -ForegroundColor DarkRed -BackgroundColor Cyan
			$fail = 1
			break			
		}
		else
		{
			switch($provider)
	        {
	            Synology {[array]$list = $synology}
	            Dyn {[array]$list = $dyn}
	            NoIP {[array]$list = $noip}
	            DyNS {[array]$list = $dyns}
	            DNSExit {[array]$list = $dnsexit}  
	        }
		}	
		foreach($ddnsprovider in $list)
		{
			$DynDNSDomains += $ddnsprovider
		}
	}
	for($u=0;$u -lt $DynDNSDomains.Count;$u++)
	{
		[string]$now = $u+1
		[string]$total = $DynDNSDomains.Count
		$domain = $DynDNSDomains[$u].ToUpper()
		Write-Progress -Activity 'Checking Search Results' -CurrentOperation "Site: $domain" -Status "$now of $total" -PercentComplete (($u / $DynDNSDomains.Count) * 100)
		$url = 'site:' + $DynDNSDomains[$u]
		if($searchterm -ne "")
		{
			$url = $searchterm + '+' + $url
		}
		if($type -eq 'image')
		{
			$GoogleString = 'http://images.google.com/search?q=' + $url + '&tbm=isch'
			$YahooString = 'http://images.search.yahoo.com/search/images?p=' + $url
		}
		elseif($type -eq 'link')
		{
			$GoogleString = 'http://www.google.com/search?q=' + $url
			$YahooString = 'http://search.yahoo.com/search?p=' + $url
		}
		else
		{
			'Invalid search type. Must be "image" or "link"'
			$fail = 1
			break
		}
		if($engine -eq 'yahoo')
		{
			$failString = "We did not find results for"
			$filterString = "Safe Search must be turned off to display these results"
			$query = $YahooString
			if($safesearch -eq 'off')
			{
				$query = $query + '&vm=p'
			}
			else
			{
				
			}
			$wait = Get-Random -Maximum 1.0 -Minimum 0.1
		}
		elseif($engine -eq 'google')
		{
			$failString = "did not match any"
			$filterString = "Safesearch On"
			$query = $GoogleString
			if($safesearch -eq 'off')
			{
				$query = $query + '&safe=off'
			}
			else
			{
				
			}
			$wait = Get-Random -Maximum 3.0 -Minimum 0.5
		}
		else
		{
			'Invalid search engine. Must be "yahoo" or "google"'
			$fail = 1
			break			
		}
		"Search URL - $query"
		$search = Invoke-WebRequest $query -Method get -UserAgent FireFox -DisableKeepAlive
		$results = $search.ParsedHtml.body
		if($results.innerText -like "*$filterString*")
		{
			Write-Host "Query triggered $engine Safe Search filter. Try removing the 'searchterm' option." -ForegroundColor DarkRed -BackgroundColor Cyan
			$fail = 1
			break
		}
		elseif($results.innerText -notlike "*$failString*")
		{
			if($query -eq 'google')
			{
				$results.innerText|Out-File ($saveto + '.temp')
				$gt = Get-Content ($saveto + '.temp')
				foreach($line in $gt)
				{
					if($line -like "*About*results*")
					{
						$count = $line.Split(' ')[1]
						"About $count results"
					}
				}
			}
			Write-Host "Results found for $domain" -ForegroundColor White -BackgroundColor DarkGreen
			$link = '<tr><td>' + $domain + '</td><td><a href="' +  $query  + '" target="_blank"><center>' + $type + 's</center></a></td><td>'
			$link|Out-File $saveto -Append
		}
		else
		{
			Write-Host ($domain + ': No Results') -ForegroundColor DarkGray -BackgroundColor White
			if($allresults -eq 'yes')
			{
				$verify = '<tr><td>' + $domain + '</td><td><center><b>none</b></center></td><td>[<a href="' +  $query  + '" target="_blank">verify</a>]</td></tr>'
				$verify|Out-File $saveto -Append				
			}
		}
		'Waiting ' + "{0:N3}" -f $wait + ' seconds'
		Start-Sleep $wait
		''
	}
	'</table>'|Out-File $saveto -Append
	if($fail -ne 1)
	{
		Write-Host "Process Complete. Output file location: $saveto" -BackgroundColor DarkBlue -ForegroundColor Cyan
	}
	else
	{
		Write-Host "Process Aborted." -BackgroundColor Black -ForegroundColor Yellow
		if((Test-Path $saveto -PathType Leaf) -eq $true)
		{
			Remove-Item $saveto -Force
		}
	}
}

#Check-DDNSsites -engine yahoo -type image -provider synology -safesearch off

## Usage: Check-DynDNSsites -engine (google|yahoo) [-provider (all|synology|dyn|noip|dyns|dnsexit)][-safesearch on|off][-type (image|link)] [-searchterm <string>] [-allresults (yes|no)] [-saveto <your save location>]
##
## engine 		= (Required) Search engine to use (Yahoo or Google) NOTE: Google may detect the scripted queries and stop responding
## provider		= (Default: all) Narrow to a single DDNS provider domain list:
##								 synology = Synology, Inc.
##								 dyn = Dyn, Inc (aka 'Dynamic Network Services')
##								 noip = no-ip.com
##								 dyns = dyns.com
##								 dnsexit = dnsexit.com
## safesearch	= (Default: on) Define as 'off' to disable any filtering of possible adult content
## type 		= (Default: Link) Type of search. Either 'image' or 'link' (aka, just a regular search)
## saveto		= (Default: Desktop) Path to where you want to save your list. If not defined, output is saved to your desktop
## allresults	= (Default: no) Return all findings including those with no results. There will be a 'verify' link added so you can check
## searchterm 	= (Default: none) Enter a string to narrow your search results
## userlist		= (Default: none) Define the path to a file with domains to search (one per line).
##                                Make sure to load the function into memory (or your profile) first!
## Examples:
## Check-DynDNSsites -type links -engine google -safesearch on
## (will return standard Google SafeSearch results for sites)
##
## Check-DynDNSsites -type images -engine google -searchterm cats -allresults yes
## (will return ALL Google Image search results (including ones with no results at all) for sites related to the string 'cats')
##
## Check-DynDNSsites -type links -engine yahoo -searchterm dogs -saveto 'C:\Users\Bob\Documents'
## (will return standard Yahoo results for sites related to the string 'dogs' and save an html file to 'C:\Users\Bob\Documents\DDNS-results.html')