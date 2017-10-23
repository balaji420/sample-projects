using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Diagnostics;
using System.Linq;
using System.ServiceProcess;
using System.Text;
using System.Threading.Tasks;
using System.Timers;

namespace Cuurency_Service
{
    public partial class Service1 : ServiceBase
    {
        private Timer timer = null;
        public Service1()
        {
            InitializeComponent();
        }

        protected override void OnStart(string[] args)
        {
            timer = new Timer();
            this.timer.Interval = 10000;
            this.timer.Elapsed += new System.Timers.ElapsedEventHandler(this.timer_tick);
            timer.Enabled = true;
            Library.WriteErrorLog("CurSer started");
            
         }

       

        private void timer_tick(object sender, ElapsedEventArgs e)
        {
            Library.WriteErrorLog("Timer ticked");
            Library.service();
        }

        protected override void OnStop()
        {
            timer.Enabled = false;
            Library.WriteErrorLog("CurSer stopped");
        }

        internal void onDebug()
        {
            OnStart(null);
        }
    }
}
