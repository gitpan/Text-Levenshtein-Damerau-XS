use warnings;
use strict;
use InlineX::C2XS qw(c2xs);
my $mod = 'Text::Levenshtein::Damerau::XS';
my $pkg = $mod;
my $build_dir = "../";
my $hashref = {
		 VERSION 		=> 0.7,
               DIST		 	=> 1,
		 EXPORT_OK_ALL	=> 1,
		 LICENSE		=> 'perl',
               CODE			=> &return_code
		};



c2xs($mod, $pkg, $build_dir, $hashref);


1;



sub return_code {
 #Return the Inline C code in a string

 return '
#define MIN(a,b) (((a)<(b))?(a):(b))

int cxs_edistance (AV* arraySource, AV* arrayTarget) { 
    int i;
    int j;
    int lenSource = av_len(arraySource) ? av_len(arraySource) + 1 : 0;
    int lenTarget = av_len(arrayTarget) ? av_len(arrayTarget) + 1 : 0;
    int areEqual = 1;
    int INF = 1;

    int arrJoined [lenSource + lenTarget];
    int arrSource [ lenSource ];
    int arrTarget [ lenTarget ];

    for (i=1; i <= lenSource; i++) {
        SV** elem = av_fetch(arraySource, i - 1, 0);
        int retval = SvNV(*elem);

        if (elem != NULL) {
            arrJoined[ INF ] = retval;
            arrSource[ i ] = retval;
            INF++;
                    
            if (i <= lenTarget && areEqual == 1) {
                SV** elem2 = av_fetch(arrayTarget, i - 1, 0);
                int retval2 = SvNV(*elem2);
                if (elem2 != NULL && retval2 != NULL) {
                    if (retval2 != retval) {
                        areEqual = 0;
                    }
                }
            }
            else {
                    areEqual = 0;
            };
        }
    }
    for (i=1; i <= lenTarget; i++) {
        SV** elem = av_fetch(arrayTarget, i - 1, 0);
        int retval = SvNV(*elem);
        if (elem != NULL) {
            arrJoined[ INF ] = retval;
            arrTarget[ i ] = retval;
            INF++;
        }
    }

    if ( lenSource == 0) { 
        if ( lenTarget == 0) { 
            return 0; 
        } 
        else { 
            return lenTarget; 
        } 
    } 
    else if ( lenTarget == 0) { 
        return lenSource; 
    } 
    else if ( lenSource == lenTarget && areEqual == 1 ) { 
        return 0; 
    }

    int H [INF][INF]; 
        
    H[0][0] = INF;

    for (i = 0; i <= lenSource; i++) { 
        H[i + 1][1] = i; 
        H[i + 1][0] = INF; 
    } 
    for (j = 0; j <= lenTarget; j++) { 
        H[1][j + 1] = j; 
        H[0][j + 1] = INF; 
    }

    int sd[30000]; 

    i = 0;
    for (i = 1; i < INF; i++) { 
        sd[ arrJoined[ i ] ] = 0; 
    } 

    for (i = 1; i <= lenSource; i++) { 
        int DB = 0;

        for (j = 1; j <= lenTarget; j++) { 
            int i1 = sd[ arrTarget[j]]; 
            int j1 = DB;

            if( arrSource[i] == arrTarget[j] ) { 
                H[i + 1][j + 1] = H[i][j]; 
                DB = j; 
            } 
            else { 
                H[i + 1][j + 1] = MIN(H[i][j], MIN(H[i + 1][j], H[i][j + 1])) + 1; 
            } 
                
            H[i + 1][j + 1] = MIN(H[i + 1][j + 1], H[i1][j1] + (i - i1 - 1) + 1 + (j - j1 - 1));
        }

        sd[ arrSource[i] ] = i; 
    }

    return H[lenSource + 1][lenTarget + 1];
}
'; #END OF CODE STRING

}

__END__