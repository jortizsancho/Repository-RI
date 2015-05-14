/*
Modified BSD License
====================

Copyright (c) 2015, CoNWeTLab, Universidad Politecnica Madrid
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:
* Redistributions of source code must retain the above copyright
notice, this list of conditions and the following disclaimer.
* Redistributions in binary form must reproduce the above copyright
notice, this list of conditions and the following disclaimer in the
documentation and/or other materials provided with the distribution.
* Neither the name of the SAP AG nor the
names of its contributors may be used to endorse or promote products
derived from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL SAP AG BE LIABLE FOR ANY
DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/
package org.fiware.apps.repository.oauth2;

//import org.apache.commons.codec.binary.Base64;
import com.sun.org.apache.xerces.internal.impl.dv.util.Base64;
import org.scribe.builder.api.DefaultApi20;
import org.scribe.model.OAuthConfig;
import org.scribe.model.OAuthConstants;
import org.scribe.model.OAuthRequest;
import org.scribe.model.ProxyOAuthRequest;
import org.scribe.model.Response;
import org.scribe.model.Token;
import org.scribe.model.Verifier;
import org.scribe.oauth.ProxyOAuth20ServiceImpl;

/**
 *
 * @author jortiz
 */
public class ProxyOAuthServiceImpl extends ProxyOAuth20ServiceImpl {
    
    public ProxyOAuthServiceImpl(DefaultApi20 api, OAuthConfig config, int connectTimeout, int readTimeout, String proxyHost, int proxyPort) {
        super(api, config, connectTimeout, readTimeout, proxyHost, proxyPort);
    }

    public ProxyOAuthServiceImpl(DefaultApi20 api, OAuthConfig config, int connectTimeout, int readTimeout, String proxyHost, int proxyPort, boolean getParameter, boolean addGrantType) {
        super(api, config, connectTimeout, readTimeout, proxyHost, proxyPort, getParameter, addGrantType);
    }

    @Override
    public Token getAccessToken(final Token requestToken, final Verifier verifier) {
        final OAuthRequest request = new ProxyOAuthRequest(this.api.getAccessTokenVerb(),
                                                           this.api.getAccessTokenEndpoint(), this.connectTimeout,
                                                           this.readTimeout, this.proxyHost, this.proxyPort);
        
        String oauth2Header = this.config.getApiKey() + ":" + this.config.getApiSecret();
        request.addHeader("Authorization", "Basic " + Base64.encode(oauth2Header.getBytes()));
        
        if (this.getParameter) {
            request.addQuerystringParameter(OAuthConstants.CLIENT_ID, this.config.getApiKey());
            request.addQuerystringParameter(OAuthConstants.CLIENT_SECRET, this.config.getApiSecret());
            request.addQuerystringParameter(OAuthConstants.CODE, verifier.getValue());
            request.addQuerystringParameter(OAuthConstants.REDIRECT_URI, this.config.getCallback());
            if (this.config.hasScope()) {
                request.addQuerystringParameter(OAuthConstants.SCOPE, this.config.getScope());
            }
            if (this.addGrantType) {
                request.addQuerystringParameter("grant_type", "authorization_code");
            }
        } else {
            request.addBodyParameter(OAuthConstants.CLIENT_ID, this.config.getApiKey());
            request.addBodyParameter(OAuthConstants.CLIENT_SECRET, this.config.getApiSecret());
            request.addBodyParameter(OAuthConstants.CODE, verifier.getValue());
            request.addBodyParameter(OAuthConstants.REDIRECT_URI, this.config.getCallback());
            if (this.config.hasScope()) {
                request.addBodyParameter(OAuthConstants.SCOPE, this.config.getScope());
            }
            if (this.addGrantType) {
                request.addBodyParameter("grant_type", "authorization_code");
            }
        }
        final Response response = request.send();
        return this.api.getAccessTokenExtractor().extract(response.getBody());
    }
    
}
