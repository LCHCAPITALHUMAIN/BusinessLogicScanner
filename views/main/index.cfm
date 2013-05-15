<cfoutput>

	<cfif arrayLen(prc.results)>
		<h2>Fix these!</h2>
		<br>
		<ul>
			<cfloop array="#prc.results#" index="file">
				<li>#file#</li>
			</cfloop> 
		</ul>
	<cfelse>
		<h2>Your app checks out!</h2>
	</cfif>
	
</cfoutput>