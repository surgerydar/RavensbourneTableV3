.pragma library

function hook(baseUrl) {
    return  "var fields = document.querySelectorAll( 'input[type=\"text\"],input[type=\"email\"],input[type=\"password\"],input[type=\"search\"]' );
        fields.forEach( function( field ) {
            field.onfocus = function() {
                console.log('edit|'+this.id+'|'+this.value );
            }
            field.readonly = true;
        } );
        var links = document.querySelectorAll('a');
        links.forEach( function(link) {
            var href = link.href.trim();
            if ( ( href.startsWith( 'http' ) && !( href.startsWith('<baseurl>') || href.startsWith( 'https://www.materialconnexion.com' ) ) ) ||
                href.startsWith('mailto') ||
                href.startsWith('javascript:void(0)') ) {
                console.log( 'disabled href=' + href );
                //link.style.visibility = 'hidden';
                link.style.opacity = '.5';
                link.href = '';
            } else {
                console.log( 'enabled href=' + href );
            }
        } );
        var footer = document.querySelector('.footer');
        if ( footer ) {
            footer.style.display = 'none';
        }
        var account = document.querySelector('.my-account-link');
        if ( account ) {
            account.style.display = 'none';
        }
        account = document.querySelector('.skip-account');
        if ( account ) {
            account.style.display = 'none';
        }
        var addthis = document.querySelector( '.addthis_toolbox' );
        if ( addthis ) {
            addthis.style.display = 'none';
        }
    ".replace('<baseurl>', baseUrl);

}

function update( id, value ) {
    return "document.querySelector('#<id>').value ='<value>';".replace('<id>', id ).replace( '<value>', value );
}

function action( id ) {
    return "var field = document.querySelector('#<id>');\
    if ( field ) {
        var submit = field.parentElement.querySelector('button[type=\"submit\"]');
        if ( submit ) {
            submit.click();
        } else {
            var evt = document.createEvent('Event');
            evt.initEvent('keypress');
            evt.which = evt.keyCode = 13;
            field.dispatchEvent(evt);
        }
    }".replace('<id>', id );
}

var keys = [
    ['1','2','3','4','5','6','7','8','9','0','-','del'],
    ['q','w','e','r','t','y','u','i','o','p'],
    ['a','s','d','f','g','h','j','k','l'],
    ['@','z','x','c','v','b','n','m','.'],
];

