// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get appTitle => 'Instalador do Musily';

  @override
  String get updateTitle => 'Atualizar Musily';

  @override
  String get installTitle => 'Instalar Musily';

  @override
  String get uninstallTitle => 'Desinstalar Musily';

  @override
  String get warningUninstall => 'Aviso: Desinstalar Musily';

  @override
  String get warningUninstallMessage => 'Isto removerá o Musily do seu sistema. A sua biblioteca de música e preferências serão eliminadas.';

  @override
  String get uninstallConfirmation => 'Eu entendo que esta ação não pode ser desfeita';

  @override
  String get removeAppData => 'Remover todos os dados da aplicação';

  @override
  String get uninstallButton => 'Desinstalar Musily';

  @override
  String get updateAvailable => 'Atualização Disponível';

  @override
  String currentVersion(String version) {
    return 'Versão atual: $version';
  }

  @override
  String get installationProgress => 'Progresso da Instalação';

  @override
  String get uninstallationProgress => 'Progresso da Desinstalação';

  @override
  String get updateProgress => 'Progresso da Atualização';

  @override
  String get showTerminalOutput => 'Mostrar saída do terminal';

  @override
  String get installationComplete => 'Instalação Concluída';

  @override
  String get uninstallationComplete => 'Desinstalação Concluída';

  @override
  String get updateComplete => 'Atualização Concluída';

  @override
  String get installationCompleteMessage => 'O Musily foi instalado com sucesso no seu sistema.';

  @override
  String get uninstallationCompleteMessage => 'O Musily foi removido com sucesso do seu sistema.';

  @override
  String get updateCompleteMessage => 'O Musily foi atualizado com sucesso.';

  @override
  String get runAfterInstall => 'Executar o Musily após a instalação';

  @override
  String get finish => 'Terminar';

  @override
  String get next => 'Seguinte';

  @override
  String get back => 'Voltar';

  @override
  String get cancel => 'Cancelar';

  @override
  String error(String message) {
    return 'Erro: $message';
  }

  @override
  String get changeLanguage => 'Alterar idioma';

  @override
  String get checkingMusily => 'A verificar se o Musily está em execução...';

  @override
  String foundRunningMusily(String pid) {
    return 'Encontrado processo do Musily em execução (PID: $pid), a terminar...';
  }

  @override
  String get musilyTerminated => 'Processo do Musily terminado com sucesso';

  @override
  String get removingAppFiles => 'A remover ficheiros da aplicação...';

  @override
  String get removingAppData => 'A remover dados da aplicação...';

  @override
  String get appDataRemoved => 'Dados da aplicação removidos com sucesso';

  @override
  String failedRemoveData(String error) {
    return 'Falha ao remover os dados da aplicação: $error';
  }

  @override
  String get updatingDesktopDb => 'A atualizar a base de dados do ambiente de trabalho...';

  @override
  String get failedUpdateDb => 'Falha ao atualizar a base de dados do ambiente de trabalho';

  @override
  String get unableToTerminate => 'Não foi possível terminar o Musily. Por favor, feche-o manualmente.';

  @override
  String get installingDependencies => 'A instalar dependências em falta...';

  @override
  String get dependenciesInstalled => 'Dependências instaladas com sucesso.';

  @override
  String get failedInstallDeps => 'Falha ao instalar dependências';

  @override
  String get backingUpConfig => 'A fazer cópia de segurança da configuração...';

  @override
  String get restoringConfig => 'A restaurar configuração...';

  @override
  String get installingIcon => 'A instalar ícone da aplicação...';

  @override
  String get creatingDesktopEntry => 'A criar entrada no ambiente de trabalho...';
}

/// The translations for Portuguese, as used in Brazil (`pt_BR`).
class AppLocalizationsPtBr extends AppLocalizationsPt {
  AppLocalizationsPtBr(): super('pt_BR');

  @override
  String get appTitle => 'Instalador do Musily';

  @override
  String get updateTitle => 'Atualizar Musily';

  @override
  String get installTitle => 'Instalar Musily';

  @override
  String get uninstallTitle => 'Desinstalar Musily';

  @override
  String get warningUninstall => 'Desinstalar Musily';

  @override
  String get warningUninstallMessage => 'Isso removerá o Musily do seu sistema. Sua biblioteca de música e preferências serão excluídas.';

  @override
  String get uninstallConfirmation => 'Eu entendo que esta ação não pode ser desfeita';

  @override
  String get removeAppData => 'Remover todos os dados do aplicativo';

  @override
  String get uninstallButton => 'Desinstalar Musily';

  @override
  String get updateAvailable => 'Atualização Disponível';

  @override
  String currentVersion(String version) {
    return 'Versão atual: $version';
  }

  @override
  String get installationProgress => 'Progresso da Instalação';

  @override
  String get uninstallationProgress => 'Progresso da Desinstalação';

  @override
  String get updateProgress => 'Progresso da Atualização';

  @override
  String get showTerminalOutput => 'Mostrar saída do terminal';

  @override
  String get installationComplete => 'Instalação Concluída';

  @override
  String get uninstallationComplete => 'Desinstalação Concluída';

  @override
  String get updateComplete => 'Atualização Concluída';

  @override
  String get installationCompleteMessage => 'O Musily foi instalado com sucesso no seu sistema.';

  @override
  String get uninstallationCompleteMessage => 'O Musily foi removido com sucesso do seu sistema.';

  @override
  String get updateCompleteMessage => 'O Musily foi atualizado com sucesso.';

  @override
  String get runAfterInstall => 'Executar o Musily após a instalação';

  @override
  String get finish => 'Finalizar';

  @override
  String get next => 'Próximo';

  @override
  String get back => 'Voltar';

  @override
  String get cancel => 'Cancelar';

  @override
  String error(String message) {
    return 'Erro: $message';
  }

  @override
  String get changeLanguage => 'Alterar idioma';

  @override
  String get checkingMusily => 'Verificando se o Musily está em execução...';

  @override
  String foundRunningMusily(String pid) {
    return 'Encontrado processo do Musily em execução (PID: $pid), terminando...';
  }

  @override
  String get musilyTerminated => 'Processo do Musily terminado com sucesso';

  @override
  String get removingAppFiles => 'Removendo arquivos do aplicativo...';

  @override
  String get removingAppData => 'Removendo dados do aplicativo...';

  @override
  String get appDataRemoved => 'Dados do aplicativo removidos com sucesso';

  @override
  String failedRemoveData(String error) {
    return 'Falha ao remover os dados do aplicativo: $error';
  }

  @override
  String get updatingDesktopDb => 'Atualizando banco de dados do desktop...';

  @override
  String get failedUpdateDb => 'Falha ao atualizar o banco de dados do desktop';

  @override
  String get unableToTerminate => 'Não foi possível terminar o Musily. Por favor, feche-o manualmente.';

  @override
  String get installingDependencies => 'Instalando dependências ausentes...';

  @override
  String get dependenciesInstalled => 'Dependências instaladas com sucesso.';

  @override
  String get failedInstallDeps => 'Falha ao instalar dependências';

  @override
  String get backingUpConfig => 'Fazendo backup da configuração...';

  @override
  String get restoringConfig => 'Restaurando configuração...';

  @override
  String get installingIcon => 'Instalando ícone do aplicativo...';

  @override
  String get creatingDesktopEntry => 'Criando entrada na área de trabalho...';
}
