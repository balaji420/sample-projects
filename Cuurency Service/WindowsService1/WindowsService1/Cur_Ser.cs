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

namespace WindowsService1
{
    public partial class Cur_Ser : ServiceBase
    {
        private Timer timer = null;
        public Cur_Ser()
        {
            InitializeComponent();
           // _scheduleTime = DateTime.Today.AddDays(1).AddHours(7); 
        }

        protected override void OnStart(string[] args)
        {
            timer = new Timer();
            //this.timer.Interval = 43200000/4;
            this.timer.Interval = 100000; //100000;//*3600);
            this.timer.Elapsed += new System.Timers.ElapsedEventHandler(this.timer_tick);
            timer.Enabled = true;
            Library.WriteErrorLog("CurSer started");
            timer.AutoReset = true;
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

        public DateTime _scheduleTime { get; set; }
    }
}

