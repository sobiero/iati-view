<?php

namespace Iati\Main;

use Phalcon\Loader;
use Phalcon\Mvc\Dispatcher;
use Phalcon\DiInterface;

class Module
{

	public function registerAutoloaders()
	{

		$loader = new Loader();

		$loader->registerNamespaces(array(
			'Iati\Main' => '../apps/main/classes/',
		));

		$loader->register();
	}

	/**
	 * Register the services here to make them general or register in the ModuleDefinition to make them module-specific
	 */
	public function registerServices(DiInterface $di)
	{

		//Registering a dispatcher
		$di->set('dispatcher', function() {
			$dispatcher = new Dispatcher(); //$di->getShared('dispatcher'); //new Dispatcher();
			$dispatcher->setDefaultNamespace("Iati\Main\Controllers");
			return $dispatcher;
		});
	}

}
