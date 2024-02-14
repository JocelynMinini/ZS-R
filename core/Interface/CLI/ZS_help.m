function ZS_help(doc)
%-------------------------------------------------------------------------------
% Name:           ZS_help
% Purpose:        Open the user manual
% Last Update:    26.10.2023
%-------------------------------------------------------------------------------
ZS_ROOT = ZS_R_rootPath;
UQ_ROOT = uq_rootPath;
ZS_manual_path = [ZS_ROOT,'\Documentation\Rep-ZS+R.pdf'];
UQ_manual_path = [UQ_ROOT,'\Doc\Manuals'];


if ~exist('doc','var')
    winopen(ZS_manual_path)
else

switch doc
    case 'alr'
    winopen(fullfile(UQ_manual_path,'UserManual_ActiveLearningReliability.pdf'))
    case 'bayesian'
    winopen(fullfile(UQ_manual_path,'UserManual_Bayesian.pdf'))
    case 'dispatcher'
    winopen(fullfile(UQ_manual_path,'UserManual_Dispatcher.pdf'))
    case 'inference'
    winopen(fullfile(UQ_manual_path,'UserManual_Inference.pdf'))
    case 'input'
    winopen(fullfile(UQ_manual_path,'UserManual_Input.pdf'))
    case 'kriging'
    winopen(fullfile(UQ_manual_path,'UserManual_Kriging.pdf'))
    case 'lra'
    winopen(fullfile(UQ_manual_path,'UserManual_LowRankApproximation.pdf'))
    case 'model'
    winopen(fullfile(UQ_manual_path,'UserManual_Model.pdf'))
    case 'pck'
    winopen(fullfile(UQ_manual_path,'UserManual_PCKriging.pdf'))
    case 'pce'
    winopen(fullfile(UQ_manual_path,'UserManual_PolynomialChaos.pdf'))
    case 'rf'
    winopen(fullfile(UQ_manual_path,'UserManual_RandomField.pdf'))
    case 'rbdo'
    winopen(fullfile(UQ_manual_path,'UserManual_RBDO.pdf'))
    case 'reliability'
    winopen(fullfile(UQ_manual_path,'UserManual_Reliability.pdf'))
    case 'sensitivity'
    winopen(fullfile(UQ_manual_path,'UserManual_Sensitivity.pdf'))
    case 'sse'
    winopen(fullfile(UQ_manual_path,'UserManual_SSE.pdf'))
    case 'svmc'
    winopen(fullfile(UQ_manual_path,'UserManual_SupportVectorMachinesClassification.pdf'))
    case 'svmr'
    winopen(fullfile(UQ_manual_path,'UserManual_SupportVectorMachinesRegression.pdf'))
    case 'uqlib'
    winopen(fullfile(UQ_manual_path,'UserManual_UQLib.pdf'))
    case 'uqlink'
    winopen(fullfile(UQ_manual_path,'UserManual_UQLink.pdf'))
    case '?'
    fprintf('\nHere below are all supported acronyms.\n')
    fprintf('Please chose the corresponding one in the list : \n\n')
    fprintf("no argument   : ZS+R manual\n")
    fprintf("'alr'         : Active learning reliability\n")
    fprintf("'bayesian'    : Bayesian analysis\n")
    fprintf("'dispatcher'  : Dispatcher module\n")
    fprintf("'inference'   : Statistical inference\n")
    fprintf("'input'       : Input module\n")
    fprintf("'kriging'     : Kriging model\n")
    fprintf("'lra'         : Low rank approximation\n")
    fprintf("'model'       : Model module\n")
    fprintf("'pck'         : Polynomial chaos Kriging\n")
    fprintf("'pce'         : Polynomial chaos expansion\n")
    fprintf("'rf'          : Random fields\n")
    fprintf("'sse'         : Stochastic spectral embedding\n")
    fprintf("'svmc'        : Support vector machine classification\n")
    fprintf("'svmr'        : Support vector machine regression\n")
    fprintf("'uqlib'       : UQLab library\n")
    fprintf("'UQLink'      : UQLink module\n")
    otherwise
    fprintf('\nError : no manual could be linked with the input.\n')
    fprintf('Please refer to the following arguments : \n\n')
    fprintf("no argument   : ZS+R manual\n")
    fprintf("'alr'         : Active learning reliability\n")
    fprintf("'bayesian'    : Bayesian analysis\n")
    fprintf("'dispatcher'  : Dispatcher module\n")
    fprintf("'inference'   : Statistical inference\n")
    fprintf("'input'       : Input module\n")
    fprintf("'kriging'     : Kriging model\n")
    fprintf("'lra'         : Low rank approximation\n")
    fprintf("'model'       : Model module\n")
    fprintf("'pck'         : Polynomial chaos Kriging\n")
    fprintf("'pce'         : Polynomial chaos expansion\n")
    fprintf("'rf'          : Random fields\n")
    fprintf("'sse'         : Stochastic spectral embedding\n")
    fprintf("'svmc'        : Support vector machine classification\n")
    fprintf("'svmr'        : Support vector machine regression\n")
    fprintf("'uqlib'       : UQLab library\n")
    fprintf("'UQLink'      : UQLink module\n")
end
end

end