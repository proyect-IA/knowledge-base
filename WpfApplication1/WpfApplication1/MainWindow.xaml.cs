﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Data;
using System.Windows.Documents;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Imaging;
using System.Windows.Navigation;
using System.Windows.Shapes;

namespace WpfApplication1
{
    /// <summary>
    /// Lógica de interacción para MainWindow.xaml
    /// </summary>
    public partial class MainWindow : Window
    {
        private ControlVisual controlVisual { get; set; }
               
        /// <summary>
        /// Constructor de la clase
        /// </summary>
        public MainWindow()
        {
            InitializeComponent();
            controlVisual = new ControlVisual(this);
        }
        
        /// <summary>
        /// Método que 
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void Button_Click(object sender, RoutedEventArgs e)
        {
            controlVisual.iniciarConstruccionDeArbol();
        }


        private void correr_simulacion(object sender, RoutedEventArgs e)
        {

        }
    }
}
